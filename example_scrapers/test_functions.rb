require 'lib/scrubyt' 
require 'pp'



extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch   'http://alphapropertyservices.com/search-results.php?letsaleID=1&propertyCategoryID=2&propertyTypeID=%25&valueFrom=100&valueTo=9999999&numberRooms=%25&areaID=%25&Submit=Search'
  
  postcode "//li[@class='address']", :function => :extract_postcode
end  

pp extractor.results       




extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch   'http://www.dorsetlettings.co.uk/property/detail.php?propid=572'
  
  description "//div[@class='pad2']", :function => :grab_longest_text, 
                                      :script => lambda {|x|x.gsub("\302\240",'')}
end  

pp extractor.results       

