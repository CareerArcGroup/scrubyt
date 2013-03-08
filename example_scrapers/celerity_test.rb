require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.alphapropertyservices.com/'
  #check          "//input[@value='2' and @type='radio']"
  submit         "//input[@name='Submit']"

  
  record "//div[@class='proLine' and position()<5]" do  
=begin    
    price           "./div[1]/div[1]", :grab => /\xC2\xA3(.+)/
    display_address "./div[3]/ul[1]/li[1]"
    summary         "./div[3]/p[1]"
    bedrooms        "./div[3]/ul[2]/li[3]", :grab => /Bedrooms:\s+(\d+)/m
    full_postcode   "./div[3]/ul[1]/li[1]", :grab => /[A-Z]{1,2}\d{1,2}/ 
    property_type   "./div[3]/ul[2]/li[2]", :grab => /Type:\s+(.+)/m
=end
    page_detail "//div[@class='viewdetails']/a[1]" do
       description     "//body/div[1]/div[1]/div[3]/div[1]/div[1]/div[4]/p[1]", :html_content => true
       #images          "//div[@class='smallphoto']/a/img", :attribute => :src, :script => lambda{|x| 'http://www.alphapropertyservices.com/' +  x.sub('120x120','270x200')}
       branch_fax      "//body/div[1]/div[1]/div[1]/div[2]/p[3]", :grab => /F: (.+)/
       branch_email    "//body/div[1]/div[1]/div[1]/div[2]/p[4]/a[1]"
       branch_phone    "//body/div[1]/div[1]/div[1]/div[2]/p[2]", :grab => /T: (.+)/
       branch_postcode "//body/div[1]/div[1]/div[1]/div[2]/p[1]", :grab => /[A-Z]{1,2}\d{1,2} \d[A-Z][A-Z]/
       current_url     'current_url'
       agent_ref       'current_url', :grab => /ID=(\d+)/
    end
  end
  next_page "//div[contains(.,'Results:') and not(descendant::div) and position()=1]/a[preceding-sibling::strong]"
end


pp extractor.results