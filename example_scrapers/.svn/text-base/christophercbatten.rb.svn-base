require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript=>true, :crawling_strategy => :default) do
  fetch          'http://www.christopherbatten.co.uk/propertylist.asp'
  submit         "//input[@class='button1']" 
                                
  record "//body/table/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/table" do
    thumbnail "./tbody[1]/tr[1]/td[1]/a[1]/img", :attribute => :src
    page_detail "//a[@class='fulldetails']" do
      display_address "//table[@class='tableborder']/tbody[1]/tr[1]/td[1]"
    end
  end
  next_page "//input[contains(@value,'Next Page')]"
end

pp extractor.results