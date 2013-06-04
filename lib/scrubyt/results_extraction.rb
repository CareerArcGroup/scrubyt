#require 'ruby-debug'
module Scrubyt
  module ResultsExtraction 
    include Scrubyt::Functions
    private
      def save_result(name, result)
        if array_of_strings?(result)
          @results << result.map{|r| {name => r} }
        elsif nested_result_set?(result)
          @results = result
        elsif appending_to_results?
          @results.first << { name => result.empty? ? nil : result }
        elsif result.is_a?(Array)
          @results << {} unless @results.first
          @results.first[name] = result.first
        else
          @results << {} unless @results.first
          @results.first[name] = result
        end
        if parent_result?
          notify(:save_results, name, @results)
        end
        clear_current_result!
      end

      def parent_result?
        @options[:parent]
      end
            
      def first_child?
        @options[:first_child]
      end
      
      def appending_to_results?
        @results.first.is_a?(Array)
      end
      
      def is_ancestor_of(ancestor,element)
        loop do
          return true if element.parent == ancestor
          element = element.parent
          return false unless element
        end
      end

      def extract_result(result_name, locator, options = {})
        begin
        return @current_result if @current_result 
        results = []
        if locator == "source"
          result = current_agent.html
          results << process_proc(result, options[:script])
          return results
        elsif locator == "current_url"
          result = grab_result(current_agent.url, options[:grab])
          results << process_proc(result, options[:script])
          return results
        else 
          debugger if options[:debug]          
          if locator.is_a?(Array)
            if options[:compound]
              all_matched_elements = locator.map{|l| evaluate_xpath(l,options[:base_frame_url]).to_a}
              matching_elements = []
              while(!all_matched_elements.empty?) do
                all_matched_elements.size.times do |i|
                  next_element = all_matched_elements[i].shift
                  if merged_element.root
                    merged_element.root.add_child next_element
                  else
                    merged_element.add_child next_element
                  end
                end
                matching_elements << merged_element
                all_matched_elements.reject!{|e| e.size < 1}
              end
            else
              matching_elements = locator.map{|l| evaluate_xpath(l,options[:base_frame_url])}.flatten
            end
          else                            
            matching_elements = evaluate_xpath(locator,options[:base_frame_url])
            #remove since Selenium gets this wrong. Instead see added positional logic in constructing full_xpath
            #if @options[:parent_element]
            #  unless @options[:firewatir] # already sorted
            #    matching_elements = matching_elements.select {|r| is_ancestor_of(@options[:parent_element],r)}
            #  end
            #end
          end
           
          @options[:xpath_hierarchy].delete_if{|e| e[0] == result_name.to_s }
          
          return merge_elements(matching_elements, options[:script]) if merge_elements?(locator)
          matching_elements.each do |element|
            #order of evaluating a result:
            #
            # 1) apply a function to it if any
            #    1a) 1b) based on the context of the function
            # 2) regexp out stuff with :grab
            # 3) apply :script on the result  
            result = get_value(element, options[:html_content] ? :html : attribute(options, :text))
            result = if(options[:function])
              if(element_context?(options[:function]))
                eval("#{options[:function].to_s}(element)")
              else
                eval("#{options[:function].to_s}(result)")
              end
            else
              result
            end
            
            result = grab_result(result, options[:grab])
            results << process_proc(result, options[:script])
          end
        end  
   
        if(@options[:ajax_post] && result_name.to_s == 'images')
          ckey = results[0]
          require 'mechanize'
          agent = Mechanize.new
          params = {'contextKey' => ckey}.to_json
          ajax_headers = { 'X-Requested-With' => 'XMLHttpRequest', 'Content-Type' => 'application/json; charset=utf-8', 'Accept' => 'application/json, text/javascript, */*'}
          response = agent.post('http://www.completed.co.uk/WebPages/PropertyImages.asmx/GetSlides',params,ajax_headers)
          return @current_result = [response.body.scan(/\/Files\/Images\/\d+.jpg/).map{|x|"http://www.completed.co.uk#{x}"}.join(',')]          
        end
=begin        
        ## Deals with XPath not always matching nth child properly. Look into
        ## A better solution
        return @current_result = [results.first] if locator.is_a?(String) && locator.match(%r{\[1\]$})
        ## Shortcut to return the last sibling element 
        return @current_result = [results.last] if locator.is_a?(String) && locator.match(%r{\[-1\]$})
=end        
        ## Return a limited resultset
        return @current_result = [results.join(options[:join_separator] || " ")] if options[:join_result]
          
        return @current_result = results[0...options[:limit]] if options[:limit]
        ## Return only non-nil/empty results. Look at porting rails #blank?
        return @current_result = results.compact.reject{|r| r == ""} if options[:required]        
        @current_result = results 
        rescue Exception => err
          puts $!, $@
        end        
      end  
      
      def evaluate_xpath(xpath, base_frame_url = nil)
        begin        
          if(xpath =~ /frameset|iframe|frame/i)
            xpath = clean_xpath(xpath)
            ## split up the cleaned XPath to 2 parts:
            ## - frame_path - just to grab the src attribute of the frame to navigate there
            ## - element_path - the 'real' XPath pointing into the frame document
            frame_path = xpath.scan(/.+frame.+?\]/)[0]
            element_path = xpath[frame_path.size..-1]   
            ## go there
            ## TODO - how do we know whether we are still in that frame or not?!!?!?!?!?!
            frame_src = @options[:agent].element(:xpath => frame_path).attribute_value("src")
            full_url = base_frame_url ? (base_frame_url + frame_src) : frame_src              
          
            frame_browser = Watir::Browser.new
            notify(:fetch_frame, full_url)
            frame_browser.goto(full_url)
          
            ## and evaluate the XPath  
            frame_browser.elements(:xpath => element_path)
          else  
            #find the index of the last element ending in _detail
            idx = @options[:xpath_hierarchy].inject(-1){|a,v| a = @options[:xpath_hierarchy].index(v) if (v[0] =~ /detail/); a}
            #and go from there
            active_xpaths = @options[:xpath_hierarchy][idx+1..-1] 

            joiner = @options[:parent_index].nil? ? "" : "[#{1 + @options[:parent_index]}]"
            full_xpath = active_xpaths.map{|x|x[1].sub(/^\./,'')}.join(joiner)

            if(@options[:firewatir])
              if(active_xpaths.size>1) 
                parent_xpath =  active_xpaths[0..-2].map{|x|x[1].sub(/^\./,'')}.join   
                current_agent.elements_by_relative_xpath(parent_xpath, full_xpath, options[:parent_index])
              else         
                current_agent.elements(:xpath => full_xpath)
              end
            else   
              current_agent.elements(:xpath => full_xpath)
            end
          end
        rescue Exception
          puts $!, $@
        end        
      end
      
      def extract_detail(result_name, *args, &block)   
        locators = args.shift
        locators = [locators] unless locators.is_a?(Array)
        if args.include?({:compound => true})
          all_matched_elements = locators.map{|l| evaluate_xpath(l).to_a}
          matching_elements = []
          while(!all_matched_elements.empty?) do
            all_matched_elements.size.times do |i|
              if merged_element.root
                merged_element.root.add_child all_matched_elements[i].shift
              else
                merged_element.add_child all_matched_elements[i].shift
              end
            end
            matching_elements << merged_element
            all_matched_elements.reject!{|e| e.size < 1}
          end
          results = matching_elements.map do |element|
            options = @options
            options.delete(:hash)
            content = element.html rescue nil
            child_extractor_options = options.merge(:use_current_page => true,
                                                    :detail => true, 
                                                    :first_child => options[:parent],
                                                    :content => content)
            result = { result_name => Extractor.new(child_extractor_options, &block).results }
            notify(:save_results, result_name, result) if first_child?
            result
          end
        else
          #index of the pattern result 
          idx = 0
          results = locators.map do |locator|
            evaluate_xpath(locator).map do |element|
              options = @options
              options.delete(:json)
              options[:json] = args.detect{|h| h.has_key?(:json)}[:json].to_json if args.detect{|h| h.has_key?(:json)}
              content = element.html rescue nil
              context = content

              child_extractor_options = options.merge(:use_current_page => true,
                                                      :detail => true,
                                                      :first_child => options[:parent],  
                                                      :parent_index => idx,  
                                                      :parent_element => element,
                                                      :agent => @agent,
                                                      :content => content)
              idx += 1
              result = { result_name => Extractor.new(child_extractor_options, &block).results }
              notify(:save_results, result_name, result) if first_child?
              result
            end
          end.flatten
        end                                    
        @options[:xpath_hierarchy].delete_if{|e| e[0] == result_name.to_s }          
        return results unless first_child?
      end
      
      def merge_results(results, proc)
        process_proc(results.to_s, options[:script])
      end
      
      def get_value(element, attribute)
        return element.html if attribute == :html
        attribute == :text ? element.text : element.attribute_value(attribute.to_s)
      end
      
      def attribute(options, default = :href)
        options = options.first if options.is_a?(Array)
        return default if options.nil? || options.empty?        
        options[:attribute] || options["attribute"] || default
      end
      
      def should_return_result?(result, all_required)
        return false if result.empty?
        return false if (all_required && missing_a_result?(result))
        true
      end
      
      def missing_a_result?(result)
        return true if result.detect{|fields| fields.detect{|k,v| v.nil?}}
      end
      
      def array_of_strings?(results)
        results.is_a?(Array) && results.first.is_a?(String)
      end
      
      def nested_result_set?(results)
        results.is_a?(Array) && results.first && results.first.values.first.is_a?(Array)
      end
      
      def wants_current_url?(method_name)
        method_name == :current_url
      end
      
      def wants_html?(method_name)
        method_name == :html
      end   
      
      def wants_source?(method_name)
        method_name == :source
      end

      def missing_required_results?(method_name, *args)
        if has_result_definition?(*args)
          result = extract_result(method_name, *args)
          options = args.last.is_a?(Hash) ? args.last : {}
          return options[:required] && result.compact.empty?
        end
      end

      def drop_empty_result?(method_name, *args)
        if has_result_definition?(*args)
          result = extract_result(method_name, *args) || []
          options = args.last.is_a?(Hash) ? args.last : {}
          return result.compact.empty? && options[:remove_blank]
        end
      end

      def result_node?(method_name, *args)
        if has_result_definition?(*args)
          result = extract_result(method_name, *args)
          return true if result.size < 2
        end
      end
      
      def result_set?(method_name, *args)
        result = extract_result(method_name, *args)
        return true if has_result_definition?(*args) && result.size > 1
      end
      
      def reset_required_failure!
        @required_failure = false
      end
      
      def required_failure!
        clear_results!
        @required_failure = true
      end
      
      def required_failure?
        @required_failure ||= false
      end

      def has_result_definition?(*args)
        return false if args.empty?
        return true if args.first == "current_url"
        return true if args.first == "source"
        return true if args.first.is_a?(Array) && args.first.first.match(%r{(^//)|(^/[a-zA-Z])|(^\./)})
        args.first.match(%r{(^//)|(^/[a-zA-Z])|(^\./)})
      end
      
      def process_proc(string_input, proc)
        begin
          if proc
            if proc.is_a?(Proc)
              string_input = proc.call(string_input)
            else
              string_input = eval(proc).call(string_input)
            end
          end
        rescue
          puts $!, $@
        end
        string_input
      end
      
      def grab_result(string_input, regexp)
        return string_input unless regexp
        if regexp.is_a?(String)
          modifiers = []
          regexp, requested_modifiers = regexp.split(%r{/([im])+$}x)
          regexp.gsub!(%r{^/|/$}, "")
          modifiers << Regexp::IGNORECASE if requested_modifiers =~ /i/i
          modifiers << Regexp::MULTILINE if requested_modifiers =~ /m/i
          regexp = Regexp.new(regexp, *modifiers) 
        end
        result = string_input.scan(regexp)
        if result.first.is_a?(Array)
          result.first.first
        else
          result.join(",")
        end
      end
      
      def merge_elements?(locator)
        return false if locator.is_a?(Array)
        locator.match(%r{/\*$})
      end
      
      def clean_xpath(xpath)
        if xpath.is_a?(Hash) && (xpath.has_key?("xpath") || xpath.has_key?(:xpath))
          xpath = xpath["xpath"] || xpath[:xpath]
        end
        xpath = xpath.sub(%r{^\./},"//")#.gsub(%r{/tbody},"")
        xpath = xpath.sub(%r{^/([a-zA-Z])},"/html/body/\\1")
        xpath = xpath.sub(/^\/\/\//, "//")
        xpath
      end
  end
end
