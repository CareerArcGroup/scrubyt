require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch   'http://snestates.com/index.php?op=search&pt=&pp_min=&pp_max=&pb=&pl=&po=S&x=26&y=17'
      
  table "//table[@class='lrp_bg']" do
    price "//p[contains(.,'Price:')]" 
  end
  next_page "//div[@align='center']/p/a[contains(.,'<<page_no>>')]", :crawl_on_numbers => true
  #"//table[@id='leftbox']/tbody/tr/td/table/tbody/tr/td/table/tbody/tr/td/div/p/a[contains(.,'<<page_no>>')]"  
end

pp extractor.results