require 'rubygems'
require 'scrubyt'

class Bestbuy_2_Scraper
  def initialize
    open('bestbuy_2_results.yaml','w')    
  end
  
  def parse_location(loc)
    loc.split(', ')
  end
  
  def scrape_page(url, button)
    extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true, :crawling_strategy => :back) do
      fetch  url
      submit "//input[@name='SearchButton']" if button
      
      record "//table[not(descendant::table) and descendant::a[@title='Sort by Job Title']]/tbody/tr[position()>2]" do
        job_title "/td[1]/a"
        category  "/td[2]"
        location  "/td[3]"        
        link "/td[1]/a", :attribute => :href, :script => lambda{|x|"http://www.recruitingsite.com/csbsites/futureshop/english/#{x}"}
      end
      
      next_page "//span/a[text()='<<page_no>>']", :crawl_on_numbers => true, :next_set => "//span/a[contains(.,'Next 20')]"
    end   
    
    extractor.results.each do |res|
      r = Result.new(res)
      return unless r.location 
      city, state = parse_location(r.location) 
      
      d_extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
        fetch  r.link

        description "//td[@id='description']", :html_content => true
      end
      
      description = d_extractor.results[0][:description]
      
      result_hash = {
        :job_title => r.job_title,
        :category => r.category,
        :city => city,
        :state => state,
        :country => 'Canada',
        :description => description,
        :link => r.link,
        :job_id => r.link.scan(/JobNumber=(\d+)/).flatten[0]
      }.to_yaml

      open('bestbuy_2_results.yaml','a') {|f| f.puts result_hash}
    end
  end   
  
  def scrape!
    scrape_page('http://www.recruitingsite.com/csbsites/futureshop/english/joblisting.asp?SuperCategoryCode=13038',false)
    scrape_page('http://www.recruitingsite.com/csbsites/futureshop/english/joblisting.asp?SuperCategoryCode=12888', true)
  end
end

scraper = Bestbuy_2_Scraper.new
scraper.scrape!