require 'lib/scrubyt'
json = [{:fetch=>"http://www.brookbanksonline.co.uk/"},
 {:submit=>"//input[@id='Submit1']"}, 
 {:record=>{
    :block=>[
        {:price=>{:regexp=>"/d/", :xpath=>"./tbody/tr[1]/td[2]/span/b"}, 
         :page_detail=>{
            :block=>[
                {:map_detail=>{
                    :block=>[
                      {:latitude=>{:xpath=>"//body/div[1]/div[3]/div[2]/div/div[4]/div[2]/table/tbody/tr[3]/td/span[2]"}, 
                       :longitude=>{:xpath=>"//body/div[1]/div[3]/div[2]/div/div[4]/div[2]/table/tbody/tr[4]/td/span[2]"}}], 
                    :xpath=>"//body/table[1]/tbody/tr/td[2]/table[2]/tbody/tr/td[4]/table[2]/tbody/tr[3]/td/table/tbody/tr/td/table/tbody/tr[5]/td/a"}, 
                 :agent_ref=>{:url=>"current_url", :regexp=>"/=(. )/"}, 
                 :images=>{:xpath=>"//body/table[1]/tbody/tr/td[2]/table[2]/tbody/tr/td[4]/table[2]/tbody/tr[2]/td/table/tbody/tr/td[1]/img"}, 
                 :branch_name=>{:regexp=>"/(. ) on/", :xpath=>"//body/table[1]/tbody/tr/td[2]/table[2]/tbody/tr/td[4]/table[2]/tbody/tr[3]/td/table/tbody/tr/td/table/tbody/tr[7]/td/b[2]"}, 
                 :branch_phone=>{:regexp=>"/d  d /", :xpath=>"//body/table[1]/tbody/tr/td[2]/table[2]/tbody/tr/td[4]/table[2]/tbody/tr[3]/td/table/tbody/tr/td/table/tbody/tr[7]/td/b[2]"}, 
                 :description=>{:xpath=>"//body/table[1]/tbody/tr/td[2]/table[2]/tbody/tr/td[4]/table[2]/tbody/tr[3]/td/table/tbody/tr/td/table/tbody/tr[3]/td"}}], 
             :xpath=>"./tbody/tr[2]/td/a"}, 
          :summary=>{:xpath=>"./tbody/tr[1]/td[2]/div"}, 
          :display_address=>{:xpath=>"./tbody/tr[1]/td[2]/span/i"}}], :xpath=>"//body/table/tbody/tr/td/table[@class='PlainWhiteBack']/tbody/tr/td/table[@class='PlainWhiteBack blackborder-top']"}}, 
  {:next_page=>{:xpath=>"//a/img[@alt='Next Page']"}}]

        
ext = Scrubyt::Extractor.new(:json => json.to_json)
puts ext.results.inspect