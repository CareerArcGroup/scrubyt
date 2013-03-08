require 'pp'
require '../lib/scrubyt'


extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true) do
  fetch "http://www.careersatsap.com/en/FindYourJob.aspx"
  
  links  "//table[@class='officesList']//li/a"#, :attribute => :href
end

pp extractor.results
exit



extractor = Scrubyt::Extractor.new(:log_level => :verbose, :javascript => true) do
  fetch "https://ejobs.sap-ag.de/sap(bD1lbiZjPTAwMSZkPW1pbg==)/bc/bsp/sap/zhrrcf_unrgs_us/application.do?BspClient=001&BspLanguage=EN&rcfcontext=US&country=USA"
  submit "//a[@id='mainsa_ZUSUnregSearchPosting_ZUSUnregSearchPosting_search']"
  

  record "//table[@class='urSAPTable']/tbody/tr[position()>2 and position()<5]" do
    job_category "/td[2]"    
    job_title    "/td[3]"
    job_id       "/td[4]"
    state        "/td[6]"
    city         "/td[7]"    
  end
  next_page "//a[@id='mainsa_ZUSUnregSearchPosting_UnregPostingHitlist_resultList_hitlisttab_pager-btn-4']", :limit => 2
end  

pp extractor.results
