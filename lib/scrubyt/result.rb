class Result
 def initialize(s, separator = ",")
   @struc = s
   @separator = separator
 end

 def method_missing(name,*params)
   @result = nil
   @struc.each {|data| drill_for data,name}
   @result
 end

 def drill_for(data,name)
   case data
     when Array:
       data.each{|d| drill_for(d,name)}
     when Hash:
       if data[name]
         if @result
           @result+= "#{@separator}#{data[name]}"
         else
           @result = data[name]            
         end
       else
         data.each do |k,v| 
           if v.is_a? Array 
             drill_for(v, name)
           else
             nil
           end
         end
       end
    else nil
   end
 end
end