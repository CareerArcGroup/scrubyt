require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
  fetch    'http://www.stirlingackroyd.com/search.aspx?ListingType=5&location=&status=0,3&igid=&imgid=9&egid=&emgid=&category=1&defaultlistingtype=5'

  record "//div[@class='ResultHolder']" do
    page_detail "./div[@class='ListResultContainer' and position()=2]/a[@class='fullDetails' and position()=1]" do
       latitude "//iframe[1]//input[@id='txtproperty_latitude']", :attribute => :value, :base_frame_url => 'http://www.stirlingackroyd.com/'
       longitude "//iframe[1]//input[@id='txtproperty_longitude']", :attribute => :value, :base_frame_url => 'http://www.stirlingackroyd.com/'
    end
  end

  #next_page "//a[child::img[@src='http://www.vebra.com/home/vebra/images/h2v/right-arrow.gif']]", :limit => 2
end                                                                                                           

pp extractor.results


