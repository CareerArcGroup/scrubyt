module Scrubyt
  module Navigation   
    module FormHelpers
   
      private
        def submit(xpath)
          return if @options[:perform_click]
          notify(:submit, xpath)
          @agent.element_by_xpath(xpath).click   
          @options[:navigation_steps] << [:submit, xpath] unless @options[:navigation_steps].include?([:submit, xpath])
        end
        
        def check(xpath)              
          return if @options[:perform_click]          
          notify(:check, xpath) 
          @agent.element_by_xpath(xpath).click
        end        
        
        def click(xpath)  
          return if @options[:perform_click]
          notify(:click, xpath)
          @options[:navigation_steps] << [:click, xpath] unless @options[:navigation_steps].include?([:click, xpath])
          @agent.element_by_xpath(xpath).click 
          sleep(@options[:rate_limit]) if @options[:rate_limit] 
        end        
        
        def click_popup(xpath)  
          return if @options[:perform_click]
          notify(:click, xpath)
          @options[:navigation_steps] << [:click_popup, xpath] unless @options[:navigation_steps].include?([:click, xpath])
          @agent = @agent.element_by_xpath(xpath).click_and_attach
        end        
        
        
        def uncheck(xpath)
          return if @options[:perform_click]          
          notify(:uncheck)
          @agent.element_by_xpath(xpath).uncheck
        end
        
        def click_link(xpath, wait_seconds=0)
          return if @options[:perform_click]          
          notify(:click_link, xpath)
          @agent.element_by_xpath(xpath).click
          sleep wait_seconds
        end 
        
        def click_link_with_index(xpath, index, wait_seconds=0)
          return if @options[:perform_click]          
          notify(:click_link_with_index, xpath, index)
          @agent.elements_by_xpath(xpath)[index].click
          sleep wait_seconds          
        end

        def fill_textfield(xpath, value="")
          return if @options[:perform_click]
          xpath, value = *xpath.split('@@@@@') if(value="" && xpath.include?('@@@@@'))
          notify(:fill_textfield, xpath, value)   
          @agent.element_by_xpath(xpath).set(value)
        end

        def select_option(how, what, option_text)
          return if @options[:perform_click]          
          notify(:select_option, how, what, option_text)
          @options[:navigation_steps] << [:select_option, how, what, option_text] unless @options[:navigation_steps].include?([:select_option, how, what, option_text])
          @agent.select_list(how, what).clearSelection
          @agent.select_list(how, what).select(option_text)
        end    
        
        def select_option_using_value(how, what, value)
          return if @options[:perform_click]          
          notify(:select_option, how, what, value)
          @options[:navigation_steps] << [:select_option_using_value, how, what, value] unless @options[:navigation_steps].include?([:select_option_using_value, how, what, value])
          @agent.select_list(how, what).clearSelection
          @agent.select_list(how, what).select_value(value)
        end            
           
        def check_checkbox(xpath)
          return if @options[:perform_click]
          notify(:check_checkbox, xpath)
          @agent.element_by_xpath(xpath).set(true)
        end
    end
  end
end