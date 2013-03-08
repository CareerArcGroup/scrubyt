require '../lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose, :firewatir => true) do
  fetch          'http://www.vebra.com/home/solex/search.asp?firmid=11046&branchid=0&dbtype=1&norefine=1'
  submit         "//input[@src='http://www.vebra.com/home/vebra/images/h2v/btn_search.gif']"

  
  record "//body/table/tbody/tr/td/table[@id='content']/tbody/tr/td/table[@class='MainTable']/tbody/tr/td/table[@class='PropImgDesc'][1]" do

    page_detail "/tbody[1]/tr[1]/td[1]/a[1]" do
      display_address "//h2[@class='DetailsAddress']"
      map_detail "//li[@class='DetailsMapLink']/a[1]" do
        latitude "//a[@title='Click to see this area on Google Maps']", :attribute => :href
      end
    end
  end 

end


pp extractor.results        

#"//div[@class='proLine' and position()<5]/div[1]/div[1]"