require "#{File.dirname(__FILE__)}/../spec_helper.rb"
require "#{File.dirname(__FILE__)}/../../lib/scrubyt.rb"

input = [{
  :name => "Atlanta Jobtitle and Link",
  :url => "file://#{File.dirname(__FILE__)}/atl.html",
  :record_xpath => "//table[@class='NEOGOV_joblist']/tbody/tr[position()>0 and child::td[@class='jobtitle']]",
  :next_page_xpath => "//form[@id='jobPagination_start']//input[@alt='Next Page' and not(@disabled)]",
  :execution_block => Proc.new do
        job_title "//a[@class='jobtitle']"
        link "//a[@class='jobtitle']", :attribute => :href, :script => lambda{|x| "#{x =~ /file?:/  ? '' : "file://#{File.dirname(__FILE__)}/"}#{x.gsub(/&WDDXJobSearchParams=.+$/,'')}"}
  end,
  :expected_output =>  [
     {:job_title=>"Asset Protection & Investigation Manager", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=658555&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Aviation Security Systems Assistant", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=654966&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Call Center Court Clerk", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=661910&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Civil Engineer, Senior", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=659499&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Communications Electronic Tech, Sr.", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=639329&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Contract Compliance Specialist", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=661095&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Data/Reporting Analyst", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=655366&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"E911 Communications Director", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=632774&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Fleet Analyst", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=646966&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Legislative Research and Policy Analyst ...", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=650281&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Police Crime Analyst", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=654887&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Pollution Control Maintenance Manager", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=653109&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Pretrial Release Officer", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=661921&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Vehicle for Hire Enforcement Officer (D)", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=662206&hit_count=yes&headerFooter=1&promo=0&transfer=0"},
     {:job_title=>"Watershed Plant Operator, Class I (Waste...", :link=>"file://#{File.dirname(__FILE__)}/default.cfm?action=viewJob&jobID=661676&hit_count=yes&headerFooter=1&promo=0&transfer=0"}]
}]




















describe "Scrubyt Testing" do
  input.each do |test|

    context "scrapes #{test[:name]}" do
      extractor = Scrubyt::Extractor.new(:log_level => :verbose) do
        fetch test[:url]
        record test[:record_xpath], &test[:execution_block]
        next_page test[:next_page_xpath]
      end

      output = []
      extractor.results.each {|r| output << r[:record].inject({}) {|k, h| k[h.keys.first] = h.values.first; k} }

      test[:expected_output].each_with_index do |item, i|
        it "record #{i+1} should match" do
          output[i].should eql item
        end
      end

    end
  end
end
