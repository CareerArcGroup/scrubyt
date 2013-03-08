require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch          'http://costelloproperty.com/property.php'

  record "//div[@id='container']/div[@id='propertyList']/span/div" do
    price "./ul[1]/li[3]"
    page_detail "//a[1]" do
      description "//body[@class='thrColFixHdr' and position()=1]/div[1]/div[4]/div[1]/p[@class='maintext' and position()=3]"
    end
  end

  next_page "//div[@id='propertyList']/span/a[@class='maintext' and contains(.,'<<page_no>>')]", :crawl_on_numbers => true
end

pp extractor.results

#price "//div[@id='container']/div[@id='propertyList']/span/div/ul[1]/li[3]"
#detail "//div[@id='container']/div[@id='propertyList']/span/div//a[1]"
#next "//div[@id='propertyList']/span/a[@class='maintext' and contains(.,'2')]"
                             

=begin
--- 
- :fetch: http://costelloproperty.com/property.php
- :geodata: 
    :script: lambda{|x| x.scan(/= new GLatLng\((-?[\d\.]+?), (-?[\d\.]+?)\)/).map{|y|y.join('@@@')}.join('###')}
    :xpath: //script[contains(.,'GLatLng')]
- :record: 
    :block: 
    - :price: 
        :grab: \d+
        :xpath: ./ul[1]/li[3]
      :price_qualifier: 
        :grab: \d\s+(.+)
        :xpath: ./ul[1]/li[3]
      :page_detail: 
        :block: 
        - :images: 
            :script: lambda{|x| "http://costelloproperty.com/#{x}"}
            :attribute: href
            :xpath: //div[@id='detailPics']/a[position()>1]
          :thumbnail: 
            :script: lambda{|x| "http://costelloproperty.com/#{x}"}
            :attribute: href
            :xpath: //div[@id='detailPics']/a[1]
          :agent_ref: 
            :grab: /=(\d+)/
            :url: current_url
          :description: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[4]/div[1]/p[@class='maintext' and position()=3]
          :branch_postcode: 
            :grab: /[A-Z]{1,2}\d{1,2} \d[A-Z][A-Z]/
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[6]/p[1]/span[2]
          :features: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[4]/div[1]/ul[@class='listindent' and position()=1]
          :transaction_type: 
            :script: lambda{'Lettings'}
            :xpath: //html
          :summary: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[4]/div[1]/p[@class='maintext' and position()=3]
          :bedrooms: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[3]/table[1]/tbody[1]/tr[1]/td[1]
          :furnished: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[3]/table[1]/tbody[1]/tr[2]/td[1]
          :branch_phone: 
            :xpath: //body[@class='thrColFixHdr' and position()=1]/div[1]/div[6]/p[1]/span[3]
        :xpath: ./a[1]
      :display_address: 
        :xpath: ./ul[1]/li[1]
    :xpath: //div[@id='container']/div[@id='propertyList']/span/div
- :next_page: 
    :crawl_on_numbers: true
    :xpath: //div[@id='propertyList']/span/a[@class='maintext' and contains(.,'<<page_no>>')]    
=end