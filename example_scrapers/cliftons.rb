require 'rubygems'
require '../lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.clifftons.com/Buying_a_property'
  submit         "//input[@value='Search']" 
                                
  record "//table[@class='results' and position()<3]" do
    price "//div[contains(.,'Price:')]"
    page_detail "//a[contains(.,'More details')]" do
      branch_phone "//div[@class='resultyellow' and contains(.,'Telephone:')]"
      photo_detail "//a[contains(.,'Photos')]" do
        images "//div[@class='gallery']/img", :attribute => :src
      end
    end
  end
  next_page "//a[text()='next']", :limit => 3
end

pp extractor.results
                            