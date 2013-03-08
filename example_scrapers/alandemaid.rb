require 'rubygems'
require 'lib/scrubyt'
require 'pp'

extractor = Scrubyt::Extractor.new(:log_level => :verbose,:rate_limit => 1) do
  fetch          'http://www.alandemaid.co.uk/'
  submit         "//input[@class='formButton']" 
  click          "//a[@title='Go to next set']"
  click          "//a[@href='offset290']"  
                                
  record "//body/div[@class='pageContainer clearfix']/div[@class='clearfix']/div[@class='']/div[@class='module cwea_results_mod_obj']/ul[@class='itemList searchResults']/li[1]" do
    summary "./p[@class='pbrief']"
    page_detail "/table[2]/tr[1]/td[1]/a[1]" do
      features "//td[@class='detailBullets']"
    end
  end
  #next_page "//a[@title='Go to next page']"
end

pp extractor.results
                             

=begin
--- 
- :fetch: http://www.alandemaid.co.uk/
- :submit: //input[@class='formButton']
- :click: //a[@title='Go to next set']
- :click: //a[@href='offset290']
- :record: 
    :block: 
    - :summary: 
        :xpath: ./p[@class='pbrief']
    :xpath: //body/div[@class='pageContainer clearfix']/div[@class='clearfix']/div[@class='']/div[@class='module cwea_results_mod_obj']/ul[@class='itemList searchResults']/li[1]
- :next_page:
    :xpath: //a[@title='Go to next page']     
=end