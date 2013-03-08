require 'rubygems'
require 'lib/scrubyt'
require 'pp'


extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch    'http://www.dorsetlettings.co.uk/property/detail.php?propid=803'
  
  description "//div[@class='pad2']", :function => :grab_longest_text
end
    
 

pp extractor.results
exit



extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch    'http://www.dorsetlettings.co.uk/'
  submit   '//body/div[1]/div[3]/div[1]/div[1]/form[1]/label[5]/input[1]'

  record "//div[@class='prop']" do
    price "./div[@class='propdesc' and position()=2]/h4[1]/a[1]"
    page_detail ".//a[text()='view property details']" do
       office_on "//div[@class='action']//strong[contains(.,'office on')]"
    end
  end

  #next_page "//div[@id='propertyList']/span/a[@class='maintext' and contains(.,'<<page_no>>')]", :crawl_on_numbers => true
end

pp extractor.results
                             

=begin
--- 
- :fetch: http://www.dorsetlettings.co.uk/
- :submit: //body/div[1]/div[3]/div[1]/div[1]/form[1]/label[5]/input[1]
- :record: 
    :block: 
    - :price_qualifier: 
        :script: lambda{|x| "pcm"}
        :xpath: ./div[@class='propdesc' and position()=2]/h4[1]/a[1]
      :price: 
        :grab: /(\d+).mth/
        :xpath: ./div[@class='propdesc' and position()=2]/h4[1]/a[1]
      :page_detail: 
        :block: 
        - :images: 
            :script: lambda{|x|dir,name = x.scan(/props\/(.+?)\/.+?\/(.+)/).flatten; "http://www.dorsetlettings.co.uk/x/props/#{dir}/#{name}" }
            :attribute: src
            :xpath: //a[@class='toc']/img
          :available_date: 
            :grab: "/Availability : (.+)/"
            :xpath: //h3[contains(.,'Availability :')]
          :description: 
            :function: grab_longest_text
            :xpath: //div[@class='pad2']
          :agent_ref: 
            :grab: propid=(.+)
            :url: current_url
          :transaction_type: 
            :script: lambda{'Lettings'}
            :xpath: //html
          :current_url: 
            :url: current_url
          :branch_phone: 
            :grab: /office on (.+)/
            :xpath: //div[@class='action']//strong[contains(.,'office on')]
        :xpath: .//a[text()='view property details']
      :display_address: 
        :grab: /^(.+?-.+?) - /
        :xpath: ./div[@class='propdesc' and position()=2]/h4[1]/a[1]
      :summary: 
        :xpath: .//div[@class='propdesc']/p[2]
      :bedrooms: 
        :grab: /(\d+) bed/
        :xpath: ./div[@class='propdesc' and position()=2]/h4[1]/a[1]
    :xpath: //div[@class='prop']
- :next_page: 
    :crawl_on_numbers: true
    :xpath: //div[@class='pad2']/p[contains(.,'Page:')]/a[contains(.,'<<page_no>>')]

=end