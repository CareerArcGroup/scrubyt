require '../lib/scrubyt'

class LoblawScraper
  def initialize
    open('loblaw_results.yaml','w')
  end
  
  def scrape_categories
    extractor = Scrubyt::Extractor.new do
      fetch "https://sjobs.brassring.com/1033/ASP/TG/cim_home.asp?partnerid=25172&siteid=5235"
      click "//a[contains(.,'Search openings')]"
      
      record "//select[@id='Question12116__FORMTEXT4']" do
        category "//option[position()>1]"
        value "//option[position()>1]", :attribute => :value
      end
    end

    res = extractor.results[0][:record]
    cat_value_pairs = res[0..res.size/2-1].map{|x|x[:category]}.zip(res[res.size/2..-1].map{|x|x[:value]})
    cat_value_pairs.map{|x|x[0]} #since we are using select_option, return option texts only
  end
    
  def scrape_category(category)
    puts "Scraping category: #{category}"
    extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true, :next_page_from_scratch => true, :crawling_strategy => :default) do
      fetch "https://sjobs.brassring.com/1033/ASP/TG/cim_home.asp?partnerid=25172&siteid=5235"
      click "//a[contains(.,'Search openings')]"
      select_option :id, 'Question12116__FORMTEXT4', category
      submit "//input[@id='submit2']"
      

      record "//table[@id='MainTable']/tbody/tr[position()>2]" do
        job_title "/td[4]"
        job_id "/td[3]/a", :attribute => :href, :grab => /jobId=(\d+)/
        state "/td[7]"
        city "/td[8]"
        job_detail "/td[3]/a" do
          description "//span[@id='Job Description']", :html_content => []
          qualifications "//span[@id='Job Qualifications']", :html_content => []
        end
      end
      next_page "//a[contains(.,'Next')]"
    end
                  
    extractor.results.each do |res|
      r = Result.new(res)
      next unless r.job_title
      result_hash = {
        :job_title => r.job_title,
        :category => category,
        :description => r.description,
        :qualifications => r.qualifications,
        :city => r.city,
        :state => r.state,
        :country => "Canada",
        :link => "https://sjobs.brassring.com/1033/asp/tg/cim_jobdetail.asp?jobId=#{r.job_id}&type=search&partnerid=25172&siteid=5235",
        :job_id => r.job_id
      }.to_yaml

      open('loblaw_results.yaml','a') {|f| f.puts result_hash}
    end
  end
  
  def scrape!
    pp categories = scrape_categories
    categories.each do |category|
      scrape_category(category)
    end
  end
  
end

scraper = LoblawScraper.new
#scraper.scrape_category("Cashier")
scraper.scrape!