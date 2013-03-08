require 'rubygems'
require '../lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch    'http://www.yeomanandowen.co.uk/view.php?id=1193&pricemin=0&pricemax=0&bedsmin=0&type=0&code=&fsonly=&skip=0'

  description "//iframe[1]//div[@class='resulttext']", :script => lambda{|x|x.gsub("\302\225",'<br/>').gsub("\n",'').gsub(/INTERESTED.+/m,'')}
end                                                                                                           

pp extractor.results


