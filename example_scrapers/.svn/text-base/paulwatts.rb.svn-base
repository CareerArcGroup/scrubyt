require 'rubygems'
require 'lib/scrubyt'
require 'pp'

#
#
#
#WORKS WITH crawling_strategy :back !!!
#
#
#

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:javascript => true, :crawling_strategy => :default) do
  fetch          'http://www.paulwatts.co.uk/PropertySearch.aspx'

  record "//div[@class='propertysummary-noborder' or @class='propertysummary' and position()<3]" do
    display_address "//div[@class='propertysummary-content']/h4"
    page_detail "//a[@title='Full details']" do
      price "//div[@id='property-info']/h4[1]"
      #description "//div[@id='col_3']/p[not(@style) and position()<last()]", :join_result => true, :join_separator => '</br>'
      map_detail "//a[@class='map-link']" do
        map_data "//script[contains(.,'AddPin')]", :html_content => true
      end
      summary "//title"
    end
  end
end

pp extractor.results