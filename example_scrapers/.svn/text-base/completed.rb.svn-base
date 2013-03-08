require '../lib/scrubyt'
require 'pp'
require '../plugins/scrubyt_yaml_file_output/scrubyt_yaml_file_output'

file = File.open("completed_results.yaml", "w")
extractor = Scrubyt::Extractor.new(:log_level => :verbose, :output => :yaml_file, :file => file) do
  fetch          'http://www.completed.co.uk/WebPages/properties.aspx?MaxPrice=100000000&NoOfBedrooms=0&PropertyType=|1|2|3|5|&MinPrice=0&SearchType=Sale&SchoolID=0&Location='
  
  record " //div[@class='AspNet-DataList']/table/tbody/tr[position()<3]/td/div[@class='list']" do
    summary "/div[@class='list_r' and position()=3]/p[1]"
    page_detail "/div[@class='list_r' and position()=3]/a[@class='btnFullDetails' and position()=1]" do
      branch_phone "//li[@class='agenttel']"
    end
  end 

end


pp extractor.results        

#"//div[@class='proLine' and position()<5]/div[1]/div[1]"

=begin
--- 
- :fetch: http://www.completed.co.uk/WebPages/properties.aspx?MaxPrice=100000000&NoOfBedrooms=0&PropertyType=|1|2|3|5|&MinPrice=0&SearchType=Sale&SchoolID=0&Location=
- :record: 
    :xpath: //div[@class='AspNet-DataList']/table/tbody/tr[position()<4]/td/div[@class='list']
    :block: 
      - :summary: 
          :xpath: ./div[@class='list_r' and position()=3]/p[1]
        :page_detail: 
          :xpath: ./div[@class='list_r' and position()=3]/a[@class='btnFullDetails' and position()=1]
          :block: 
            - :agent_ref: 
                :url: current_url
              :full_postcode: 
                :xpath: //a[@class='btnUpMyStreet']
                :script: lambda{|x|x.scan(/\/([A-Z\d]+)\+([A-Z\d]+)/).flatten.join}
                :attribute: href
              :link: 
                :url: current_url
              :transaction_type: 
                :xpath: //html
                :script: lambda{'Resale'}
              :branch_phone: 
                :xpath: //li[@class='agenttel']
                :grab: /[\d\s]+/
              :current_url: 
                :url: current_url
              :description: 
                :xpath: //p[@class='descript']
                :html_content: true
        :display_address: 
          :xpath: //div[contains(@class,'prop_name')]
        :price_qualifier: 
          :xpath: ./div[@class='list_r' and position()=3]/div[@class='list_details' and position()=1]/ul[@class='iconlist' and position()=1]/li[@class='priceprefix' and position()=4]
        :property_type: 
          :xpath: ./div[@class='list_r' and position()=3]/div[@class='list_details' and position()=1]/ul[@class='iconlist' and position()=1]/li[@class='detached' and position()=3]
        :status: 
          :xpath: ./div[@class='list_r' and position()=3]/div[@class='list_details' and position()=1]/ul[@class='iconlist' and position()=1]/li[@class='soldSTC' and position()=4]
          :script: "lambda{|x| x.downcase=='let' ? 'agreed' : x}"
        :bedrooms: 
          :xpath: ./div[@class='list_r' and position()=3]/div[@class='list_details' and position()=1]/ul[@class='iconlist' and position()=1]/li[@class='bed' and position()=1]
          :grab: /\d+/
        :price: 
          :xpath: //div[contains(@class,'prop_price')]
          :grab: /(\d[\d,]+)\s*/
        :bathrooms: 
          :xpath: ./div[@class='list_r' and position()=3]/div[@class='list_details' and position()=1]/ul[@class='iconlist' and position()=1]/li[@class='bath' and position()=2]
          :grab: /\d+/
        :thumbnail: 
          :xpath: //div[@class='list_pic_green']/input
          :script: lambda{|x|'http://www.completed.co.uk' + x.gsub('_small','').gsub('..','')}
          :attribute: src
- :next_page: 
    :xpath: //a[@id='ctl00_MainContent_lnkNext' and not(@disabled)]
    :limit: 2
=end    