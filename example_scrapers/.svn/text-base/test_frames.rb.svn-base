require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch   'http://www.bournemouthflatco.co.uk/sales.htm'
      
  table "//td[@id='contentBox']/p/iframe[@id='powcont']//body/form[@id='Form1']/div[@class='scrolling' and @id='divProps']/span[@id='dlProperties']/span/table[@id='propertyListing']/tbody/tr/td[@class='plLftCol']" do
    price "./table[1]/tbody[1]/tr[1]/td[1]/h4[1]/span[1]"
  end
end

=begin
--- 
- :fetch: http://www.bournemouthflatco.co.uk/sales.htm
- :record: 
    :xpath: 
    :block: 
    - :price: 
        :xpath: 
                                             

=end
pp extractor.results
