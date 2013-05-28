require "#{File.dirname(__FILE__)}/logger.rb"
require "#{File.dirname(__FILE__)}/navigation.rb"
require "#{File.dirname(__FILE__)}/results_extraction.rb"
require "#{File.dirname(__FILE__)}/inflections.rb"
require "#{File.dirname(__FILE__)}/event_dispatcher.rb"
require 'json'

module Scrubyt
  class Extractor
    include Scrubyt::EventDispatcher
    include Scrubyt::Navigation
    include Scrubyt::ResultsExtraction
    
    attr_accessor :options, :detail
    attr_reader   :extractor_definition
    DEFAULT_USER_AGENT = 'Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 6.0)'

    def initialize(options = {}, &extractor_definition)
      #@options[:xpath_hierarchy] stores XPaths leading to this pattern
      #
      #e.g. for the structure
      #
      # record "XPath 1"
      #   x "XPath 2"
      #   y "XPath 3"
      #   some_detail "XPath 4"
      #     z "XPath 5"
      #     another_detail "XPath 6"
      #
      #it contains [[:record,"XPath 1"], [:some_detail => "XPath 4"]] when evaluating z or another detail
      #thus the absolute XPath of z can be calculated as "XPath 1" + "XPath 4" + "XPath 6"
      options[:xpath_hierarchy] ||= []
      options[:parent] = !options[:parent] && !options[:child] ? true : false
      defaults = { :javascript => false,
                   :output => :hash,
                   :child => true,
                   :log_level => :none }      
      options[:navigation_steps] ||= []
      @options = defaults.merge(options)    
      #store navigation steps so that they can be replayed for the from_scratch strategy
      
      
      setup_listeners
      setup_agent
      setup_output
      setup_logger
      clear_results!
      
      @detail = []
      @detail_definition = []
      notify(:start) unless in_detail_block?
      if options[:json]
        options[:json] = JSON.parse(options[:json]) if options[:json].is_a?(String)
        execute_json(options[:json])
      else
        @extractor_definition = extractor_definition
        instance_eval(&extractor_definition)
      end
      if @json_next_defined      
        # execute_json(strip_navigation(json)) 
      end
      unless in_detail_block?
        clear_results! 
        notify(:end)
      end
    end
            
    def results
      return @results.flatten if in_detail_block?
      @options[:output_plugin].results.flatten
    end
    
    def current_agent
      @options[:popup_agent] || @options[:agent]
    end    
    
    private
      
      def method_missing(method_name, *args, &block)         
        puts "in method missing, method_name: #{method_name}, args: #{args}"
        @options[:agent] ||= @agent    
        update_xpath_hierarchy(method_name, args.first)
        #so that we can come back here when navigating to further detail pages / next pages
        @options[:original_page] = [@agent.url] if(!@options[:original_page] && @agent.respond_to?(:url))
        return fetch_next(method_name, *args, &block) if next_page?(method_name)
        return fetch_detail(method_name, *args, &block) if detail_block?(method_name, *args, &block)
        return save_result(method_name, extract_detail(method_name, *args, &block)) if result_block?(*args, &block)
        return required_failure! if missing_required_results?(method_name, *args)
        unless required_failure?  
          return save_result(:current_url, current_agent.url) if wants_current_url?(method_name)
          return save_result(:html, current_agent.html) if wants_html?(method_name)
          return if drop_empty_result?(method_name, *args)
          return save_result(method_name, extract_result(method_name, *args)) if result_node?(method_name, *args)
          return save_result(method_name, extract_result(method_name, *args)) if result_set?(method_name, *args)
          super
        end
      end
      
      def update_xpath_hierarchy(method_name_sym, xpath)
        method_name = method_name_sym.to_s
        
        unless (next_page?(method_name_sym) || 
                wants_current_url?(xpath.to_sym) ||  
                wants_html?(xpath.to_sym) ||
                wants_source?(xpath.to_sym) ||
                @options[:xpath_hierarchy].find{|x|x[0][method_name]})
          
          @options[:xpath_hierarchy] << [method_name, xpath]
        end
      end
      
      def execute_json(json)
        sanitized_json = json.dup
        begin
          sanitized_json.each{|h| h.symbolize_keys!}
          sanitized_json.each do |hash|
            hash.each do |k,v|
              case v
              when NilClass
                send k
              when String
                send(k, v)
              when Array
                  send(k, *v)
              when Hash
                if v.has_key?(:xpath) && v.has_key?(:block)
                  code = []
                  code << %Q{#{k.to_s} "#{v[:xpath]}", :json => #{v[:block].inspect}}
                  instance_eval(code.join("\n"))
                elsif v.has_key?(:xpath)
                  params = v.dup
                  element = params.delete(:xpath)
                  args = [element, params]
                  send(k, *args)
                elsif v.has_key?(:url)
                  params = v.dup
                  element = params.delete(:xpath)
                  args = ["current_url", params]                  
                  send(k, *args)
                end
              end
            end
          end
        rescue Exception
          if $!.is_a?(Scrubyt::ScrapeNextJSONPage)
            @json_next_defined = true                 
            sanitized_json = json.dup
            sanitized_json.each{|h| h.symbolize_keys!}
            sanitized_json = strip_navigation(sanitized_json)
            retry unless @options[:limit] <= 0
          else
            puts $!, $@
          end
        end
      end
      
      def strip_navigation(json)
        navigation_methods = Scrubyt::Navigation::FormHelpers.private_instance_methods - Object.private_instance_methods
        navigation_methods.each {|m| json = json.reject{|s| s.has_key?(m.to_sym) }}
        json
      end
      
      def setup_logger
        Scrubyt::Logger.new(self, @options)
      end

      def setup_output
        if @options[:output].is_a?(Symbol)
          outputter = "Scrubyt::Output::#{@options[:output].to_s.camelize}".constantize
          @options[:output_plugin] = outputter.new(self, @options)
        elsif @options[:output].is_a?(Array)
          @options[:output_plugin] = []
          @options[:output].each do |output|
            outputter = "Scrubyt::Output::#{output.to_s.camelize}".constantize
            @options[:output_plugin] = outputter.new(self, @options)
          end
        end
      end
      
      def in_detail_block?
        options[:detail]
      end
      
      def next_page?(method_name)
        method_name == :next_page
      end
      
      def detail_block?(method_name, *args, &block)
        if method_name.to_s =~ /_detail$/
          @detail_definition = [method_name, args.clone, block]
          true
        end
      end
      
      def result_block?(*args, &block)
        if args
          args.shift
          return true if args.detect{|h| h.has_key?(:json)}
        end
        ! block.nil?
      end
                      
      def setup_agent
        return if @options.delete :use_current_page                   /
        javascript_on_off = @options[:javascript] || false
        notify(:setup_agent)
        if(current_agent)       
          @agent = current_agent
        elsif @options[:firewatir] 
          require "firewatir"
          @agent = FireWatir::Firefox.new          
        else
          require 'headless'
          require 'watir-webdriver'
          x =1
          #require 'celerity'
          @headless = ::Headless.new(:display => '115')
          @headless.start
          @agent = ::Watir::Browser.new #(:user_agent => @options[:user_agent] || DEFAULT_USER_AGENT,
                                      #             :javascript_enabled => javascript_on_off,
                                      #             :resynchronize => javascript_on_off,
                                      #             :secure_ssl => false,
                                      #             :log_level => @options[:browser_log_level] || :off)
          @agent.driver.manage.timeouts.implicit_wait = 10
          #@agent = Celerity::Browser.new(:user_agent => DEFAULT_USER_AGENT, :resynchronize => true) 
          #@agent = Celerity::Browser.new(:user_agent => 'Mozilla/4.0 (compatible; MSIE 7.0b; Windows NT 6.0)', :javascript_enabled => false)
          #@agent = Celerity::Browser.new(:user_agent => @options[:user_agent] || DEFAULT_USER_AGENT,
          #                               :javascript_enabled => javascript_on_off,
          #                               :resynchronize => javascript_on_off,
          #                               :secure_ssl => false,
          #                               :log_level => @options[:browser_log_level] || :off)
        end    
        
          
        #special case: we need to click a link/button rather than fetch an URL
        #in this case we are not passing an URL, but rather the element to be clicked
        #(as @options[:perform_click]) 
        if(@options[:perform_click]) 
          fetch nil
        end        
      end
      
      def clear_current_result!
        @current_result = nil
      end
      
      def clear_results!
        @results = []
      end
         
      def get_option(args, opt)
        option = args.select{|o|o[opt]}[0]
        option ? option[opt] : nil
      end
  end
end