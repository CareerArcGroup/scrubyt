require '../lib/scrubyt'

class MotorolaScraper
  def initialize
    open('motorola_results.yaml','w')
  end
  
  def parse_location(loc)
    loc.split('-')
  end
  
  def scrape!
    extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => :true, :crawling_strategy => :default) do
      fetch "http://careers.peopleclick.com/careerscp/client_motorola/external/search.do"
      submit "//input[@id='searchButton']"

      record "//table[@id='searchResultsTable']/tbody/tr[position()>1]" do
        job_title "/td[8]/a"
        xxx      "/td[8]/a", :attribute => :href, :script => labmda{|x| "http://careers.peopleclick.com/careerscp/client_motorola/external/#{x}" }
        job_id    "/td[10]"
        location  "/td[12]"
      end
      
      next_page "//table[@id='searchResultsHeaderTable']//input[@alt='Next']", :limit => 2
    end       
    
    pp extractor.results
    exit
                  
    extractor.results.each do |res|
      r = Result.new(res)
      return unless r.location
      country, state, city = parse_location(r.location)
      
      result_hash = {
        :job_title => r.job_title,
        :category => r.category,
        :city => city,
        :state => state,
        :country => 'USA',
        :description => r.description.gsub("\n",''),
        :link => r.link,
        :job_id => r.job_id
      }.to_yaml

      open('motorola_results.yaml','a') {|f| f.puts result_hash}
    end
  end
end

scraper = MotorolaScraper.new
scraper.scrape!