require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch    'http://royalarsenalresidential.co.uk/search/sales'

  record "//div[@id='leftCol']/div[@class='property']/table//tr" do
    price "/td[2]/h2[2]"
    page_detail "./td[2]/p[2]/a[1]" do
       agent_ref "current_url", :grab => /(\d+)/
    end
  end
  next_page "//span[@class='property_search_page' and contains(.,'<<page_no>>')]", :crawl_on_numbers => true#, :limit =>2
end

pp extractor.results
                             
=begin   
price: "//div[@id='leftCol']/div[@class='property' and position()=1]/table//tr/td[2]/h2[2]"
detail: "//div[@id='leftCol']/div[@class='property' and position()=1]/table//tr/td[2]/p[2]/a[1]"   
        "//div[@id='leftCol']/div[@class='property']/table//tr/td[2]/p[2]/a[1]"   
next: "//span[@class='property_search_page' and contains(.,'2')]"
      "//span[@class='property_search_page' and contains(.,'3)]"
=end

=begin
--- 
- :fetch: http://royalarsenalresidential.co.uk/search/sales
- :record: 
    :block: 
    - :price: 
        :grab: "/\xC2\xA3(\\d{1,3},\\d{3},?\\d{0,3})/"
        :xpath: ./td[2]/h2[2]
      :summary: 
        :xpath: ./td[2]/p[1]
      :page_detail: 
        :block: 
        - :current_url: 
            :url: current_url
          :branch_phone: 
            :xpath: //div[@id='footer']/p[1]/span[4]
          :agent_ref: 
            :url: current_url
            :grab: /(\d+)/
          :description: 
            :grab: /More Details(.+)See this/m
            :xpath: //div[@id='leftCol']/div[5]
          :branch_fax: 
            :xpath: //div[@id='footer']/p[1]/span[5]
          :transaction_type: 
            :xpath: //html
            :script: lambda{'Resale'}
          :images: 
            :xpath: //a[@class='gallery_image']
            :attribute: href
            :script: lambda{|x| "http://royalarsenalresidential.co.uk#{x}"}
          :branch_postcode: 
            :grab: /[A-Z]{1,2}\d{1,2} \d[A-Z][A-Z]/
            :xpath: //body/div[1]/div[4]/p[1]/span[1]
        :xpath: ./td[2]/p[2]/a[1]
      :display_address: 
        :xpath: ./td[2]/h3[1]
      :tenure: 
        :grab: "/\xC2\xA3\\d{1,3},\\d{3},?\\d{0,3}(.+)/"
        :xpath: ./td[2]/h2[2]
      :full_postcode: 
        :grab: /[A-Z]{1,2}\d{1,2}\s?\d?[A-Z]?[A-Z]?/
        :xpath: ./td[2]/h3[1]
    :xpath: //div[@id='leftCol']/div[@class='property']/table/tr
- :next_page: 
    :xpath: //span[@class='property_search_page' and contains(.,'<<page_no>>')]
    :crawl_on_numbers: true
=end