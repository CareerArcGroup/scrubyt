require '../lib/scrubyt'
require 'pp'

scrap = <<DOZ
--- 
- :fetch: http://shop.mlb.com/product/index.jsp?productId=4287570&cp=1452371.1452625
- :submit: //input[@id='mlbAddToCart']
- :fill_textfield: //input[@id='promoBx']@@@@@WSCHAMPS
- :click: //img[@src='http://MLB.imageg.net/images/checkout/cart2_apply.gif']
- :record: 
    :xpath: //table[@id='cartItems']/tbody
    :block: 
      - :original_price: 
          :xpath: ./tr[3]/td[1]/table[@class='cartMainInfo' and position()=1]/tbody[1]/tr[1]/td[3]/table[1]/tbody[1]/tr[9]/td[2]/b[1]
DOZ

code = scrap.chop
json = YAML.load(code).to_json

scraper = Scrubyt::Extractor.new(:json => json, :log_level => :verbose, :javascript => true)
pp scraper.results

=begin

extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true) do
  fetch          'http://shop.mlb.com/product/index.jsp?productId=4287570&cp=1452371.1452625'
  submit         "//input[@id='mlbAddToCart']"
  fill_textfield "//input[@id='promoBx']@@@@@WSCHAMPS"
  click          "//img[@src='http://MLB.imageg.net/images/checkout/cart2_apply.gif']"
  
  record "//table[@id='cartItems']/tbody" do  
    original_price "./tr[3]/td[1]/table[@class='cartMainInfo' and position()=1]/tbody[1]/tr[1]/td[3]/table[1]/tbody[1]/tr[9]/td[2]/b[1]"
  end

end


pp extractor.results
=end