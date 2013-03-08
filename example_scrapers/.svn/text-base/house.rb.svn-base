require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch    'http://www.houseandson.eu/'
  submit   "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']"

  record "//body/table[@class='MainTable']//table[@class='PropImgDesc']/tbody" do
    #display_address "./tr[1]/td[2]/table[1]/tbody[1]/tr[1]/td[1]/span[@class='ResultsAddress' and position()=1]"
    page_detail "//tr[1]/td[2]/table[1]//tr[1]/td[2]/a[1]" do
       description "//div[@class='DetailsDescription']/*[not(@id='hip-info') and not(@class='paragraph dt-disclaimer')]", :html_content => true, :join_result => true
       proprtype "//div[@id='DetailsTextCol']/h1[1]", :function => :extract_property_type
    end
  end

  #next_page "//a[child::img[@src='http://www.vebra.com/home/vebra/images/h2v/right-arrow.gif']]", :limit => 2
end

pp extractor.results
                             

=begin
--- 
- :fetch: http://www.houseandson.eu/
- :submit: //input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']
- :record: 
    :block: 
    - :page_detail: 
        :block: 
        - :price: 
            :grab: /[\d,]+/
            :xpath: //body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]
          :images: 
            :attribute: src
            :xpath: //img[@class='smallimage']
          :hip: 
            :attribute: src
            :xpath: //img[@alt='Environmental impact chart']
          :description: 
            :xpath: //div[@class='DetailsDescription' and position()=1]/p[1]
          :features: 
            :xpath: //div[@class='no-results' and position()=3]/div[2]/ul[1]
          :tenure: 
            :grab: /[a-zA-z]+/
            :xpath: //body/div[1]/div[2]/h2[@class='DetailsPrice' and position()=2]
          :transaction_type: 
            :script: lambda{'Resale'}
            :xpath: //html
          :link: 
            :url: current_url
          :branch_email: 
            :xpath: //div[@class='company' and position()=2]/p[1]/a[1]
          :current_url: 
            :url: current_url
          :epc: 
            :attribute: src
            :xpath: //img[@alt='Energy efficiency chart']
        :xpath: ./tr[1]/td[2]/table[1]/tr[1]/td[2]/a[1]
      :agent_ref: 
        :script: "lambda{|x| x.scan(/ref: (\\d+)\\/(\\d+)/).join('')}"
        :xpath: ".//tr[2]/td[1]/span[contains(.,'(ref: ')]"
      :summary: 
        :xpath: ./tr[1]/td[2]/table[1]/tbody[1]/tr[2]/td[1]/span[@class='ResultsDescription' and position()=1]
      :display_address: 
        :xpath: ./tr[1]/td[2]/table[1]/tbody[1]/tr[1]/td[1]/span[@class='ResultsAddress' and position()=1]
      :thumbnail: 
        :script: lambda{|x| ''+x}
        :attribute: src
        :xpath: ./tr[1]/td[1]/a[1]/img[@class='ResultsMainImage' and position()=1]
      :branch_phone: 
        :grab: /branch on ([\d ]+)/
        :xpath: ./tr[1]/td[2]/table[1]/tbody[1]/tr[2]/td[1]/span[@class='ResultsDescription' and position()=1]
    :xpath: //body/table[@class='MainTable']/tr/td/table[@class='PropImgDesc']   
- :next_page:
    :xpath: "//a[child::img[@src='http://www.vebra.com/home/vebra/images/h2v/right-arrow.gif']]"
=end