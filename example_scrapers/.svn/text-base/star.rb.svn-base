require 'rubygems'
require '../lib/scrubyt'
require 'pp'
puts "SCUMI"
extractor = Scrubyt::Extractor.new(:log_level => :verbose,:javascript => true) do
  fetch          'http://www.bradleyandlacy.com/propertylet.html'

    record "//body/table/tbody/tr/td/table/tbody/tr/td/table/tbody" do
      agent_ref "/child::*"      
    end
end

pp extractor.results