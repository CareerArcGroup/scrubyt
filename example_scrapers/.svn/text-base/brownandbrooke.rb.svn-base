require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.brownandbrooke.co.uk/search.asp?pricetype=1'
  check          "//input[@id='pricetype1']"
  submit         "//input[@id='searchviewall']"

  record "//table[@class='results1_propertyborder']/tr[1]/td[1]" do
    price "//td[@class='results1_priceask']"
    page_detail "/table[2]/tr[1]/td[1]/a[1]" do
      features "//td[@class='detailBullets']"
    end
  end
end

pp extractor.results
                             

=begin
--- 
- :fetch: http://www.brownandbrooke.co.uk/search.asp?pricetype=1
- :check: //input[@id='pricetype1']
- :submit: //input[@id='searchviewall']
- :record: 
    :block: 
    - :price: 
        :grab: "/\xC2\xA3(\\d{1,3},\\d{3},?\\d{0,3})/"
        :xpath: //td[@class='results1_priceask']
      :page_detail: 
        :block: 
        - :images: 
            :attribute: src
            :xpath: //td[child::img[@width='65' and @border='0']]/img
        :xpath: /table[2]/tr[1]/td[1]/a[1]
    :xpath: //table[@class='results1_propertyborder']/tr[1]/td[1]
=end