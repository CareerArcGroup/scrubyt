require 'rubygems'
require 'celerity'
require 'pp'

def scrape_details_for_job(job_id)
  b = Celerity::Browser.new(:secure_ssl=>false, :resynchronize=> true)
  b.goto "https://lawsonrecruit.che.org/recruit/servlet/com.lawson.ijob.QuickCandidate?vendor=9"       
  b.element_by_xpath("//input[@name='newcandidate']").click
  b.goto "https://lawsonrecruit.che.org/recruit/servlet/com.lawson.ijob.RequisitionDetails?reqId=#{job_id}"
  category    = b.element_by_xpath("//tr[child::td[contains(.,'Category')]]/td[2]").text
  location    = b.element_by_xpath("//tr[child::td[contains(.,'Location')]]/td[2]").text
  description = b.element_by_xpath("//tbody[child::tr[contains(.,'Description')]]/tr[3]").html
  [category, location, description]
end

pp scrape_details_for_job('45564')  
