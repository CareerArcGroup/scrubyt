require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          "http://www.harbour-front.com/index.asp?d=0"
  select_option  "//option[@value='525']"
  submit         "//input[@value='search>>']"
  
  record         "//body/div[@id='ContentShell']/div[@id='ContentPanel']/div[@id='Content']/div[@id='PropertyList']/table/tbody/tr[@class='PLLineClass']/td/table[@id='SearchResults']" do
    summary      "./tr[2]/td[1]/span[1]"
  end
end

pp extractor.results

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch   'http://www.alandemaid.co.uk/'
  submit  "//input[@class='formButton']"
  
  price "//p[@class='price']"    
end

p extractor.results

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.google.com/ncr'
  fill_textfield "//input[@name='q']", 'trip'
  submit         "//input[@name='btnG']"
  
  link "//a[@class='l']"
end

p extractor.results



extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.mymatrixjobs.com'
  select_option  "//option[@value='AZ']"
  submit         "//input[@name='searchResults']"
    
  link "//a[@class='jobtitle']"
end

p extractor.results

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.rubyforge.org'
  click_link     "//a[text()='Log In']"
  fill_textfield "//input[@name='form_loginname']", 'scrubber'
  fill_textfield "//input[@name='form_pw']", 'kulacs'
  submit         "//input[@name='login']"
    
  link "//td[@class='titlebar'][1]"
end

p extractor.results

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.alphapropertyservices.com/'
  check          "//input[@value='2' and @type='radio']"
  submit         "//input[@name='Submit']"
    
  link "//li[@class='address'][1]"
end

p extractor.results