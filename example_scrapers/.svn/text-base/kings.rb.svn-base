require 'rubygems'
require '../lib/scrubyt'
require 'pp'


extractor = Scrubyt::Extractor.new(:log_level => :verbose, :crawling_strategy => :default) do
  fetch          'http://www.vebra.com/home/solex/search.asp?firmid=11148&branchid=0&dbtype=1'
  submit         "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']" 
  submit         "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_display.gif']"

  record "//body/table[@class='MainTable']/tbody/tr/td/table[@class='PropImgDesc' and position()<6]/tbody/tr" do
    summary "/td[2]/table[1]/tbody[1]/tr[2]/td[1]/span[@class='ResultsDescription' and position()=1]"
    page_detail "/td[2]/table[1]/tbody[1]/tr[1]/td[2]/a[1]" do
      map_detail "//a[contains(.,'Location Map')]" do
        lat  "//script[contains(@src,'vp=')]", :attribute => :src, :script => lambda{|x|x.scan(/vp=([\d\.]+),/).flatten[0]}
        long "//script[contains(@src,'vp=')]", :attribute => :src, :script => lambda{|x|x.scan(/vp=.+?,([-\d\.]+)/).flatten[0]}        
      end 
      price_qualifier "//body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]"      
      display_address "//body/div[1]/div[2]/h2[@class='DetailsAddress' and position()=1]"
    end
  end
end

pp extractor.results


=begin
extractor = Scrubyt::Extractor.new(:log_level => :verbose,:javascript => true, :crawling_strategy => :default) do
  fetch          'http://www.vebra.com/home/search/vdetails.asp?src=agent&cl=924&pid=17544518'

  record "//div[@id='wrap']" do
    stuff "//div[@id='DetailsTextCol']/h1[1]"    
    page_detail "//a[contains(.,'Location Map')]" do     
      pagezzz "//body", :html_content => true
    end
  end
end
=end

=begin
extractor = Scrubyt::Extractor.new(:log_level => :verbose,:javascript => true, :crawling_strategy => :default) do
  fetch          'http://www.vebra.com/home/solex/search.asp?firmid=11148&branchid=0&dbtype=1'
  submit         "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']" 
  submit         "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_display.gif']"

  record "//body/table[@class='MainTable']/tbody/tr/td/table[@class='PropImgDesc' and position()=9]/tbody/tr" do
    summary "/td[2]/table[1]/tbody[1]/tr[2]/td[1]/span[@class='ResultsDescription' and position()=1]"
    page_detail "/td[2]/table[1]/tbody[1]/tr[1]/td[2]/a[1]" do
      price_qualifier "//body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]"
      map_detail "//a[contains(.,'Location Map')]" do
        pageeooed "//body", :html_content => true
      end
    end
  end
end
=end

=begin
--- 
- :fetch: http://www.vebra.com/home/solex/search.asp?firmid=11148&branchid=0&dbtype=1
- :submit: //input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']
- :submit: //input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_display.gif']
- :record: 
    :xpath: //body/table[@class='MainTable']/tbody/tr/td/table[@class='PropImgDesc' and position()=9]/tbody/tr
    :block: 
    - :summary: 
        :xpath: ./td[2]/table[1]/tbody[1]/tr[2]/td[1]/span[@class='ResultsDescription' and position()=1]
        :grab: /(.+)Contact/m
      :page_detail: 
        :xpath: ./td[2]/table[1]/tbody[1]/tr[1]/td[2]/a[1]
        :block: 
        - :agent_ref: 
            :url: current_url
          :map_detail:
            :xpath: //a[contains(.,'Location Map')]
            :block:
            - :latitude:
                :xpath: //body
                :html_content: true
          :price_qualifier: 
            :xpath: //body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]
=end