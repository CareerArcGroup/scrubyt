require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:javascript => true) do
  fetch          'http://www.tingleys.co.uk/for-sale.asp'

    record "//div[@class='mini-prop' and position()<5]" do
      display_address "//h2[1]"
      page_detail "//a[contains(.,'More details')]" do
        price "//div[@class='mini-prop']/h2[1]"
        description "//div[@id='col_3']/p[not(@style) and position()<last()]", :join_result => true, :join_separator => "</br>" 
      end
    end
end

pp extractor.results