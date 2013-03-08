require '../lib/scrubyt'
$KCODE = "U"
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose, :firewatir => true) do
  fetch          'https://www.fehlig.de/shop.asp'
  click_link     "//body/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/ul[1]/li[1]/div[1]/a[1]", 4
  click_link     "//body/div[2]/div/div[2]/div/div/div[2]/div[2]/div/ul/li/div/div[2]/a", 4
  click_link     "//body/div[2]/div/div[2]/div/div/div[2]/div[2]/div/ul/li/div[2]/ul/li/div/div[2]/a", 4
  click_link     "//body/div[2]/div/div[2]/div/div/div[2]/div[2]/div/ul/li/div[2]/ul/li/div[2]/ul/li/div/div[2]/a", 4
  click_link     "//body/div[2]/div/div[2]/div/div/div[2]/div[2]/div/ul/li/div[2]/ul/li/div[2]/ul/li/div[2]/ul/li/div/div[2]/a", 4
  
  record "//body/div[@id='page']/div[@id='main']/div[@id='content']/div[@id='contentmiddle']/div[@class='rbmTabstrip' and @id='tabstripmiddle']/div[@class='tabContainer' and @id='tabstripmiddleC_0']/div[@id='searchResult']/div[@id='searchSecond']/div[@id='searchResult2']/ul[@class='itemList']/li[@class='item' and position()>1]" do
    price           "/div[@class='itemContent c11' and position()=3]/div[1]/table[@class='c11' and position()=1]/tbody[1]/tr[1]/td[2]"
    summary         "./div[@class='itemHeader c11' and position()=1]"
    description     "./div[@class='itemDetails c11' and position()=5]/div[1]/p[1]"
    thumbnail       "./div[@class='itemPicture' and position()=2]/img[1]", :attribute => :src, :script => lambda{|x| 'https://www.fehlig.de/' + x} 
  end

end


pp extractor.results