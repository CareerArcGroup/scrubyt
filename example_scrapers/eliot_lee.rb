require 'rubygems'
require '../lib/scrubyt'
require 'pp'


extractor = Scrubyt::Extractor.new(:log_level => :verbose, :crawling_strategy => :default) do
  fetch          'http://www.elliotlee.co.uk/form.htm'
  submit         "//input[@value='Search']"
  
  record "//body/table[@class='ResultsPropertyTable' and position()<22]/tbody/tr" do
    summary "/td[@class='ResultsDescriptionDataCell' and position()=2]/span[@class='ResultsDescription' and position()=1]"
    page_detail "/td[1]/span[1]/a[1]" do     
      display_address "//div[@id='DetailsBar']/h2[@class='DetailsAddress' and position()=1]"  
      map_detail "//a[contains(.,'Location Map')]", :manual_crawl => true, :detail_page_javascript => true do
        lat  "//script", :html_content => true, :join_result => true, :script => lambda{|x|x.scan(/vp=([\d\.]+),/).flatten[0]}
        long "//script", :html_content => true, :join_result => true, :script => lambda{|x|x.scan(/vp=.+?,([-\d\.]+)/).flatten[0]}
      end
      price_qualifier "//body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]"      
      display_address "//body/div[1]/div[2]/h2[@class='DetailsAddress' and position()=1]"
      
    end
  end
end

pp extractor.results

=begin
--- 
- :fetch: http://www.elliotlee.co.uk/form.htm
- :submit: //input[@value='Search']
- :record: 
    :xpath: //body/table[@class='ResultsPropertyTable']/tbody/tr
    :block: 
      - :summary: 
          :xpath: ./td[@class='ResultsDescriptionDataCell' and position()=2]/span[@class='ResultsDescription' and position()=1]
        :page_detail: 
          :xpath: ./td[1]/span[1]/a[1]
          :block: 
            - :agent_ref7
                :url: current_url
              :tenure: 
                :xpath: //div[@id='DetailsBar']/h2[@class='DetailsPrice' and position()=2]
              :price_qualifier: 
                :xpath: //div[@id='DetailsBar']/h2[@class='DetailsPrice' and position()=2]
              :display_address: 
                :xpath: //div[@id='DetailsBar']/h2[@class='DetailsAddress' and position()=1]
              :property_type: 
                :xpath: //div[@id='DetailsTextCol']/h1[1]
              :link: 
                :url: current_url
              :status: 
                :xpath: //div[@id='DetailsBar']/h2[@class='DetailsPrice' and position()=2]
              :branch_phone: 
                :xpath: //div[@class='company' and position()=2]/h2[1]
                :grab: /([\d\(][\d\s\(\)]+\d)/
              :images: 
                :xpath: //ul[@id='ImageList']/li/img
                :script: lambda{|x| ''+x}
                :attribute: src
              :bedrooms: 
                :xpath: //div[@id='DetailsTextCol']/h1[1]
                :grab: /\d+/
              :price: 
                :xpath: //div[@id='DetailsBar']/h2[@class='DetailsPrice' and position()=2]
                :grab: /(\d[\d,]+)\s*/
              :description: 
                :xpath: //div[@id='DetailsTextCol']
                :html_content: "true"
              :transaction_type: 
                :xpath: //html
                :script: lambda{'Resale'}
              :current_url: 
                :url: current_url
        :thumbnail: 
          :xpath: ./td[1]/span[1]/a[1]/img[@class='ResultsMainImage' and position()=1]
          :script: lambda{|x| ''+x}
          :attribute: src
- :next_page: 
    :xpath: //td[@class='ResultsNav']/a[@class='ResultsNav' and contains(.,'<<page_no>>')]
    :crawl_on_numbers: true

=end