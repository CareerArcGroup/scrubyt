require "#{File.dirname(__FILE__)}/form_helpers.rb"
module Scrubyt
  class ScrapeNextJSONPage < StandardError; end
  module Navigation
    include FormHelpers
    private
      def fetch(url)   
        sleep(@options[:rate_limit]) if @options[:rate_limit]        
        if @options[:perform_click]  
          element_to_click = @options[:perform_click]
          notify(:perform_click, element_to_click)
          options[:original_page] << @agent.url unless @options[:firewatir]
          #handle popups
          if(!@options[:firewatir] && (element_to_click.attribute_value('target') == '_blank' || element_to_click.attribute_value('target') == 'new' ))
             @options[:popup_agent] = element_to_click.click_and_attach
          else 
            element_to_click.click   
          end  
          @options[:original_page] = [@agent.url] if (!@options[:firewatir] && @options.delete(:store_page))
        else
          notify(:fetch, url)
          @options[:navigation_steps] << [:fetch, url] unless @options[:navigation_steps].include?([:fetch, url])
          @agent.goto(url)   
        end         
      rescue Errno::ETIMEDOUT
      rescue EOFError
      rescue SocketError  
        puts $!, $@
      end
                                         
    
      def fetch_next(result_name, *args)                               
        return if ((@options[:limit] == 1) || @options[:crawling_error])
        
        if(@options[:next_page_from_scratch])
          @options[:perform_click] = nil
          @agent = @options[:agent] 
          puts "Replaying navigation steps..."
          replay_navigation
          @options[:agent] = @agent           
        end
        
        reset_required_failure!
        clear_current_result!
        locator = args.shift 
        opts = args.first || {}
        crawl_on_numbers = opts.delete(:crawl_on_numbers)
                     
 
        #FIXME there is surely a better way to do this
        @options[:limit] ||= (get_option(args, :limit) || 500)
        @options[:page_no] ||= 2 #needed when crawling on number links (and not a proper next page link) 
        
        xpath = ""
        #@options[:limit].times do
        @options[:limit] -= 1
        
          link = if(crawl_on_numbers)             
            xpath = locator.sub("<<page_no>>", @options[:page_no].to_s)
            return unless(l = @agent.element(:xpath => locator.sub("<<page_no>>", @options[:page_no].to_s)))
            @options[:page_no] += 1             
            l
          else
            xpath = locator
            @agent.element(:xpath => locator)
          end

          clicking_next_set = false
          #exceptional case: link doesn't exist, but link to next_set does!
          if (!link.exists? && opts[:next_set])
            clicking_next_set = true
            link = @agent.element(:xpath => opts[:next_set])
          end    

          if link.exists?    
            #Store it as a navigation step
            if(@options[:next_page_from_scratch] && clicking_next_set)
              #if we already had this stored, and we want to store it again,
              #it means that the crawling has to stop - since we can't crawl on even 
              #after clicking the next set, and therefore we want to click the next set 
              #again
              if @options[:navigation_steps].include?([:click, opts[:next_set]])
                @options[:limit] = 1
                return 
              end                          
              @options[:navigation_steps] << [:click, opts[:next_set]]
            end  
            
            @options[:navigation_steps] << [:click, xpath]
            @options.merge!(:perform_click => link, :agent => @agent, :store_page => true)
            @options[:xpath_hierarchy] = []
            begin 
              if options[:json]
                raise ScrapeNextJSONPage.new(link)
              else
                instance_eval(&extractor_definition)
              end
            rescue Exception 
              if $!.is_a?(ScrapeNextJSONPage)     
                puts "Scraping next_page"
                raise ScrapeNextJSONPage.new(link)
              else
                puts $@
              end
              @options[:crawling_error] = true
            end
          else
            return
          end
          
        #end
      end
      
      # fetch_detail is called when there is a detail block
      # Detail blocks accept the following options
      #   :required if set to true, will not be saved if one of the fields is missing
      #   :if takes a proc that accepts the url as argument. If the proc return falses the url is skipped
      def fetch_detail(result_name, *args, &block) 
        reset_required_failure!
        locator = args.shift
        opts = args.first || {}
        all_required = opts[:required] == :all   

        #need to join previous XPath elements to get a full XPath   
        full_detail_xpath = generate_full_detail_xpath 
        #trick here -> full_detail_xpath matches all detail elements *in the whole document*,
        #regardless of the result of the parent pattern
        #remedy this by taking only the correct element, by passing the index of the currently
        #processed pattern result        
        index = detail_depth > 1 ? 0 : @options[:parent_index]         
        detail_element = current_agent.elements(:xpath => full_detail_xpath)[index]
        return if !detail_element || !detail_element.exists?     
        
        options = @options        
        child_extractor_options =  if(!@options[:automatic_map] && (opts[:manual_crawl] || result_name.to_s == "map_detail")) #argh horrible hack         
          #the problem is that when evaluating map_detail, we can't access the opts (pp opts and it will be clear what's goin on)
          javascript_on_off = opts[:detail_page_javascript] || false
          base_url = options[:detail_url_base] || ''
          
          url = if opts[:crawling_pattern]
            scraped_attribute = detail_element.attribute_value(opts[:attribute].to_s)
            scraped_text      = detail_element.text
          
            page_param = opts[:attribute] ? scraped_attribute : scraped_text
            page_param = page_param.scan(opts[:grab]).flatten[0] if opts[:grab]
            url = opts[:crawling_pattern].sub("<<page_param>>",page_param)
          else
            base_url + detail_element.href
          end
          
          notify(:next_detail, result_name, url, args) 
          agent = Watir::Browser.new(:resynchronize => true,
                                        :javascript_enabled => javascript_on_off,            
                                        :resynchronize => javascript_on_off,
                                        :secure_ssl => false)
          
          agent.goto url

          @options[:original_agent] = current_agent
          @options[:original_page_manual] = current_agent.url
          @options[:agent] = agent       
          @options.delete(:perform_click)
          @options[:popup_agent].close if @options[:popup_agent]
          @options[:popup_agent] = nil          
          @options.delete(:popup_agent)
          options[:json] = args.detect{|h| h.has_key?(:json)}[:json].to_json if args.detect{|h| h.has_key?(:json)}          
          options.merge(:use_current_page => true,
                        :detail => true,
                        :agent => agent)  
          
        else
          url = detail_element.attribute_value(:href)
          result_name = result_name.to_s.gsub(/_detail$/,"").to_sym
          notify(:next_detail, result_name, url, args)
          options.delete(:hash)
          options[:json] = args.detect{|h| h.has_key?(:json)}[:json].to_json if args.detect{|h| h.has_key?(:json)}
          options.merge(:perform_click => detail_element, 
                        :parent_element => nil,
                        :detail => true)      
        end     
        
        detail_result = Extractor.new(child_extractor_options, &block).results

        
        #remove last _detail XPath
        @options[:xpath_hierarchy].pop
        
        if(result_name.to_s == "map_detail" || opts[:manual_crawl])
          @options[:agent] = @options[:original_agent]        
          @options[:agent].page = @options[:original_page_manual]  
        elsif(@options[:popup_agent])
          @options[:popup_agent].close
          @options[:popup_agent] = nil
        else
          cs = determine_crawling_strategy
          #puts "Crawling strategy: #{cs}"
          case cs
            when :back
               @options[:agent].back 
               @options[:agent].wait
            when :default
              @options[:agent].goto @options[:original_page].pop
            when :from_scratch
              @options[:perform_click] = nil
              @agent = @options[:agent]
              replay_navigation        
              @options[:agent] = @agent  
            else
              @options[:agent].element(:xpath => cs).click
              @options[:agent].wait
          end           
        end                        
         
        if should_return_result?(detail_result, all_required)
          if options[:detail] && options[:child]
            @results << { result_name => detail_result }
          else
            @results = { result_name => detail_result }
          end
          notify(:save_results, result_name, @results)
        end
      end 
      
      def replay_navigation
        #puts "replaying navigation steps: "
        #pp @options[:navigation_steps]
        @options[:navigation_steps].clone.each do |step, *params|
          #puts "Replaying: #{step} with params: "
          begin
            send step, *params
          rescue
            puts "Can't click, dropping: [#{step}, #{params.inspect}]"
            options[:navigation_steps].reject!{|x| x[0] == step && x[1..-1] == params}
          end
        end           
      end
      
      def generate_full_detail_xpath
        result = []
        detail_found = false
        
        @options[:xpath_hierarchy].reverse.each do |pattern,xpath|
          break if(detail_found && pattern =~ /_detail$/)
          detail_found = true if(pattern =~ /_detail$/)
          result << [pattern,xpath]
        end
        
        result.reverse.map{|x|x[1].sub(/^\./,'')}.join
      end
      
      #how deep we are:
      # 0 = top level
      # 1 = first detail page or just crwaling to the first detail page
      # etc
      def detail_depth
        @options[:xpath_hierarchy].inject(0) {|a,v| a += 1 if v[0] =~ /_detail$/; a}
      end
      
      #no explicit crawling strategy
      # - :back if JS
      # - :default if non-JS
      #
      #explicit crawling strategy, either of
      # - xpath of the link to click (not a symbol, but the XPath)
      # - :from_scrath 
      # - :back
      # - :default
      def determine_crawling_strategy  
        return :back if @options[:firewatir]
        if(cs = @options[:crawling_strategy])
          if(cs.is_a? Hash)
            return cs[:xpath]
          else
            return cs.to_sym
          end
        else
          return @options[:javascript] ? :back : :default
        end
      end      
      
      
  end
end