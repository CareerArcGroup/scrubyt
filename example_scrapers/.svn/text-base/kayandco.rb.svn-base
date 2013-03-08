require 'rubygems'
require '../lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true, :rate_limit => 5) do
  fetch    'http://www.kayandco.com/search.aspx?ListingType=5&igid=&imgid=9&egid=&emgid=&category=1&defaultlistingtype=5&markettype=0&currency=GBP'
  click "//a[contains(@title,'Next to Page') and contains(@href,'PagingHeader')]"


  record "//body/form[@id='aspnetForm']/div[@class='BackGround']/div[@id='siteContainer']/div[@id='container']/div[@id='inner']/div[@id='center']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearchResultsUpdatePanel']/div[@class='pagepadding']/div[@id='pnlSearchItemsContainer']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearch_itemscontainer']/div[@class='ListSearchResult panel' and position()<3]" do
    property_type "/div[@class='ListResultContainer' and position()=2]/div[@class='SearchText' and position()=1]" 
    page_detail "/div[@class='ListResultContainer' and position()=2]/div[@class='ListResultsLinksHeight' and position()=3]/div[2]/div[@class='ListResultsLinks' and position()=1]/a[1]" do
      full_postcode "//script[contains(.,'SWFObject')]", :html_content => true, :grab => /postcode%253d%2522(.+?)%2522/
    end
  end
  
end                                                                                                           



=begin
extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true, :crawling_strategy => :default, :next_page_from_scratch => true) do
  fetch    'http://www.kayandco.com/search.aspx?ListingType=5&igid=&imgid=9&egid=&emgid=&category=1&defaultlistingtype=5&markettype=0&currency=GBP'

  record "//body/form[@id='aspnetForm']/div[@class='BackGround']/div[@id='siteContainer']/div[@id='container']/div[@id='inner']/div[@id='center']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearchResultsUpdatePanel']/div[@class='pagepadding']/div[@id='pnlSearchItemsContainer']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearch_itemscontainer']/div[@class='ListSearchResult panel' and position()<3]" do
    property_type "/div[@class='ListResultContainer' and position()=2]/div[@class='SearchText' and position()=1]" 
    page_detail "/div[@class='ListResultContainer' and position()=2]/div[@class='ListResultsLinksHeight' and position()=3]/div[2]/div[@class='ListResultsLinks' and position()=1]/a[1]" do
      full_postcode "//script[contains(.,'SWFObject')]", :html_content => true, :grab => /postcode%253d%2522(.+?)%2522/
    end
  end
  next_page "//a[contains(@title,'Next to Page')]",:limit => 2
  
end                                                                                                           
=end

pp extractor.results



=begin
 :fetch: http://www.kayandco.com/search.aspx?ListingType=5&igid=&imgid=9&egid=&emgid=&category=1&defaultlistingtype=5&markettype=0&currency=GBP
- :record: 
    :xpath: //body/form[@id='aspnetForm']/div[@class='BackGround']/div[@id='siteContainer']/div[@id='container']/div[@id='inner']/div[@id='center']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearchResultsUpdatePanel']/div[@class='pagepadding']/div[@id='pnlSearchItemsContainer']/div[@id='ctl00_cntrlCenterRegion_ctl01_cntrlSearch_itemscontainer']/div[@class='ListSearchResult panel']
    :block: 
      - :property_type: 
          :xpath: ./div[@class='ListResultContainer' and position()=2]/div[@class='SearchText' and position()=1]
        :status: 
          :script: "lambda{|x| x.downcase=='let' ? 'agreed' : x}"
          :xpath: ./div[@class='ListResultContainer' and position()=2]/h2[1]/span[@class='property-statuslabel' and position()=2]
        :page_detail: 
          :xpath: ./div[@class='ListResultContainer' and position()=2]/div[@class='ListResultsLinksHeight' and position()=3]/div[2]/div[@class='ListResultsLinks' and position()=1]/a[1]
          :block: 
            - :full_postcode: 
                :grab: /postcode%253d%2522(.+?)%2522/
                :html_content: true
                :xpath: //script[contains(.,'SWFObject')]
              :branch_phone: 
                :grab: /([\d\(][\d\s\(\)]+\d)/
                :xpath: //div[@class='FDTextContainer' and position()=1]/b[2]
              :current_page_link: 
                :url: current_url
              :description: 
                :html_content: "true"
                :xpath: //div[@class='FDTextContainer' and position()=1]/div[1]
              :transaction_type: 
                :xpath: //html
                :script: lambda{'Resale'}
              :current_url: 
                :url: current_url
              :agent_ref: 
                :url: current_url
        :summary: 
          :xpath: ./div[@class='ListResultContainer' and position()=2]/div[@class='SearchText' and position()=1]/span[1]
        :price: 
          :grab: /(\d[\d,]+)\s*/
          :xpath: ./div[@class='ListResultContainer' and position()=2]/h2[1]/span[1]
        :images: 
          :attribute: src
          :script: lambda{|x|x.gsub(/&h=(\d+)/,'').gsub(/&w=(\d+)/,'')}
          :xpath: //img[@class='smallImageExtra']
        :tenure: 
          :xpath: ./div[@class='ListResultContainer' and position()=2]/h2[1]/span[1]
        :thumbnail: 
          :attribute: src
          :script: lambda{|x|x.gsub(/&h=(\d+)/,'').gsub(/&w=(\d+)/,'')}
          :xpath: //img[@class='fulldetails-photo-item']
        :display_address: 
          :xpath: ./div[@class='ListResultContainer' and position()=2]/h3[1]/a[@class='propAdd' and position()=1]
- :next_page: 
    :xpath: //a[contains(@title,'Next to Page')]
=end