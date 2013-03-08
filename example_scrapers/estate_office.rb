require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch    'http://www.vebra.com/home/quick/PFselect.asp?firmid=1360&branchid=101&dbtype=2'
  submit   "//input[@src='http://www2.vebra.com/home/vebra/images/h2v/btn_search.gif']"
  submit   "//input[@src='http://www2.vebra.com/home/vebra/images/h2v/btn_display.gif']"
  
  record "//body/table[@class='ResultsPropertyTable'][1]" do
    summary "//tr[1]/td[@class='ResultsDescriptionDataCell' and position()=2]/span[@class='ResultsDescription' and position()=1]"
    page_detail "//tr[1]/td[1]/span[1]/a[1]" do
       price "//table[@class='DetailBar' and position()=2]/tbody/tr[1]/td[2]/span[@class='DetailsPrice' and position()=1]"
    end
  end
  #next_page "//a[child::span[contains(.,'Next')]]"
end


pp extractor.results

=begin
--- 
- :fetch: http://www.vebra.com/home/quick/PFselect.asp?firmid=1360&branchid=101&dbtype=2
- :submit: //input[@src='http://www2.vebra.com/home/vebra/images/h2v/btn_search.gif']
- :submit: //input[@src='http://www2.vebra.com/home/vebra/images/h2v/btn_display.gif']
- :record: 
    :xpath: //body/table[@class='ResultsPropertyTable' ][1]
    :block: 
      - :summary: 
          :xpath: .//tr[1]/td[@class='ResultsDescriptionDataCell' and position()=2]/span[@class='ResultsDescription' and position()=1]
        :page_detail: 
          :xpath: .//tr[1]/td[1]/span[1]/a[1]
          :block: 
            - :price: 
                :xpath: //table[@class='DetailBar' and position()=2]//tr[1]/td[2]/span[@class='DetailsPrice' and position()=1]
              :link: 
                :url: current_url

=end