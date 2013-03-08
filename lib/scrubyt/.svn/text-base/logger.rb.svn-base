module Scrubyt
  class Logger
    @@log_levels = [:none,
                    :critical,
                    :error,
                    :warn,
                    :info,
                    :debug,
                    :verbose]

    def initialize(extractor, *args)
      @log_level = @@log_levels.index(args.first[:log_level]) 
      @extractor = extractor    
      @extractor.subscribe(:start) do
        log("start") if @log_level > 3
      end
      @extractor.subscribe(:end) do
        log("end") if @log_level > 3
      end
      @extractor.subscribe(:save_result) do |name, result|
        log("saving: '#{name}'") if @log_level > 4
        log("with result: '#{result}'") if @log_level > 5
      end
      @extractor.subscribe(:fetch) do |url|
        log("fetch: #{url}") if @log_level > 4
      end
      @extractor.subscribe(:next_page) do |url|
        log("next page: #{url}") if @log_level > 3
      end
      @extractor.subscribe(:next_detail) do |name, url, *args|
        log("next detail: '#{name}' = '#{url}'") if @log_level > 4
        log("with args: '#{args}'") if @log_level > 5      
      end
      @extractor.subscribe(:submit) do |xpath|
        log("submitting form with submit button on xpath: #{xpath}") if @log_level > 4
      end
      @extractor.subscribe(:check) do |xpath|
        log("checking checkbox on xpath: #{xpath}") if @log_level > 4
      end      
      @extractor.subscribe(:click) do |xpath|
        log("clicking link on xpath: #{xpath}") if @log_level > 4
      end            
      @extractor.subscribe(:click_link) do |xpath|
        log("clicking link on xpath: #{xpath}") if @log_level > 4
      end                  
      @extractor.subscribe(:click_link_with_index) do |xpath,idx|
        log("clicking link on xpath: #{xpath}, index: #{idx}") if @log_level > 4
      end                        
      @extractor.subscribe(:fill_textfield) do |name, value, options|
        log("textfield: '#{name}' = '#{value}'") if @log_level > 4
        log("with options '#{options}'") if @log_level > 5
      end
      @extractor.subscribe(:select_option) do |how, what, option_text_or_attribute|
        log("select list: #{how} with value #{what}, option: #{option_text_or_attribute}") if @log_level > 4
      end
      @extractor.subscribe(:check_checkbox) do |xpath|
        log("checking checkbox on XPath: #{xpath}") if @log_level > 4
      end      
      @extractor.subscribe(:setup_agent) do
        log("setup agent") if @log_level > 3
      end
      @extractor.subscribe(:perform_click) do |element|
        log("crawling by clicking link: #{element.text}") if @log_level > 3
      end
      @extractor.subscribe(:fetch_frame) do |src|
        log("fetching frame: #{src}") if @log_level > 3
      end           
    end
    
    private
      def log(message)
        puts message
      end
  end
end