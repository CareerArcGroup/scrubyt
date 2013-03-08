module Scrubyt
  module Functions
    
    CONTEXT_ELEMENT = [:grab_longest_text]
    
    CONTEXT_TEXT = [:extract_postcode, :extract_property_type]
    
    def grab_longest_text(example_element)    
      longest_text = ""
    
      glt = lambda do |element|
        element.children.each do |child|
          if((child.type==1) && (child.to_s !~ /<script/) &&  (child.text.sub(/^\s*/,'').sub(/\s*$/,'').gsub(/\s{2,}/,' ').size > longest_text.size))
            longest_text = child.text.sub(/^\s*/,'').sub(/\s*$/,'').gsub(/\s{2,}/,' ')
          end
        end
        
        element.children.each {|child| glt[child] if child.type == 1}
      end    
      
      glt[example_element]
      longest_text
    end
                              
    def extract_property_type(example_text)
      house_types = ["flat share",
       "house share",
       "end of terrace house",
       "link detached house",
       "terraced bungalow",
       "semi-detached bungalow",
       "detached bungalow",
       "semi-detached villa",
       "detached villa",
       "semi-detached",
       "terraced bungalow",
       "semi-detached bungalow",
       "detached bungalow",  
       "bungalow",
       "townhouse",
       "cottage",
       "mews",
       "chalet",
       "ground floor flat",
       "flat",
       "serviced apartments",
       "apartment",
       "studio",
       "ground floor maisonette",
       "maisonette",
       "penthouse",
       "detached",       
       "house",
       "terrace"]
       
       regexps = house_types.map do |ht| 
         Regexp.new(ht, Regexp::IGNORECASE | Regexp::MULTILINE)
       end
       
       regexps.each do |re|
         return example_text.scan(re)[0].downcase if example_text =~ re
       end
       
       return ""            
    end
    
    def extract_postcode(example_text)
      #A9 9AA 
      #A99 9AA 	
      #AA9 9AA 	
      #AA99 9AA 	
      #A9A 9AA 	
      #AA9A 9AA
      example_text.upcase!
      regexps = [ 
        #full postcode
        /[A-Z]{2}\d{1}[A-Z]{1}\s*\d[A-Z]{2}/,
        /[A-Z]{1}\d{1}[A-Z]{1}\s*\d[A-Z]{2}/,
        /[A-Z]{2}\d{2}\s*\d[A-Z]{2}/,        
        /[A-Z]{2}\d{1}\s*\d[A-Z]{2}/,                        
        /[A-Z]{1}\d{2}\s*\d[A-Z]{2}/,        
        /[A-Z]{1}\d{1}\s*\d[A-Z]{2}/,
        /[A-Z]{2}\d{1}[A-Z]{1}\+\d[A-Z]{2}/,  #from href
        /[A-Z]{1}\d{1}[A-Z]{1}\+\d[A-Z]{2}/,
        /[A-Z]{2}\d{2}\+\d[A-Z]{2}/,        
        /[A-Z]{2}\d{1}\+\d[A-Z]{2}/,                        
        /[A-Z]{1}\d{2}\+\d[A-Z]{2}/,        
        /[A-Z]{1}\d{1}\+\d[A-Z]{2}/,        
        #outer postcode only
        /[A-Z]{2}\d{1}[A-Z]{1}/,
        /[A-Z]{1}\d{1}[A-Z]{1}/,
        /[A-Z]{2}\d{2}/,
        /[A-Z]{2}\d{1}/,
        /[A-Z]{1}\d{2}/,        
        /[A-Z]{1}\d{1}/
      ]
      
      regexps.each do |regexp|
        return example_text.scan(regexp)[0].gsub('+','') if example_text =~ regexp
      end
      return ""
    end
    
    def element_context?(function_name)
      (CONTEXT_ELEMENT.include? function_name) || (CONTEXT_ELEMENT.include? function_name.to_sym)
    end
  end
end
      