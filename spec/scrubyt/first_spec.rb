require "#{File.dirname(__FILE__)}/../spec_helper.rb"
require "#{File.dirname(__FILE__)}/../../lib/scrubyt.rb"

input = [{
  :name => "Atlanta Jobtitle and Link",
  :url => "file://#{File.dirname(__FILE__)}/../atl.html",
  :record_xpath => "//table[@class='NEOGOV_joblist']/tbody/tr[position()>0 and child::td[@class='jobtitle']]",
  :next_page_xpath => "//form[@id='jobPagination_start']//input[@alt='Next Page' and not(@disabled)]",
  :execution_block => Proc.new do
        job_title "//a[@class='jobtitle']"
        link "//a[@class='jobtitle']", :attribute => :href
  end,
  :expected_output =>  [
     {:job_title=>"Asset Protection & Investigation Manager", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=658555&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Aviation Security Systems Assistant", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=654966&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Call Center Court Clerk", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=661910&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Civil Engineer, Senior", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=659499&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Communications Electronic Tech, Sr.", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=639329&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Contract Compliance Specialist", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=661095&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Data/Reporting Analyst", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=655366&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"E911 Communications Director", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=632774&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Fleet Analyst", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=646966&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Legislative Research and Policy Analyst ...", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=650281&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Police Crime Analyst", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=654887&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Pollution Control Maintenance Manager", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=653109&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Pretrial Release Officer", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=661921&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Vehicle for Hire Enforcement Officer (D)", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=662206&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"},
     {:job_title=>"Watershed Plant Operator, Class I (Waste...", :link=>"file:///home/pduffy/repos/scrubyt/spec/default.cfm?action=viewJob&jobID=661676&hit_count=yes&headerFooter=1&promo=0&transfer=0&WDDXJobSearchParams=%3CwddxPacket%20version%3D%271%2E0%27%3E%3Cheader%2F%3E%3Cdata%3E%3Cstruct%3E%3Cvar%20name%3D%27CATEGORYID%27%3E%3Cstring%3E%2D1%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27PROMOTIONALJOBS%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27TRANSFER%27%3E%3Cstring%3E0%3C%2Fstring%3E%3C%2Fvar%3E%3Cvar%20name%3D%27FIND%5FKEYWORD%27%3E%3Cstring%3E%3C%2Fstring%3E%3C%2Fvar%3E%3C%2Fstruct%3E%3C%2Fdata%3E%3C%2FwddxPacket%3E"}]
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
