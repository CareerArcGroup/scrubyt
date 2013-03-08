require 'yaml'
puts "WTF"

class Scrubyt::Output::YamlFile < Scrubyt::Output::Plugin  
  @subscribers = {}
  on_initialize :setup_file
  before_extractor :open_root_node
  after_extractor :close_root_node
  on_save_result :save_yaml


  def setup_file(args = {}) 
    @file = args[:file]
  end

  def save_yaml(name, results)
    results.each do |res| 
       next unless res.is_a?(Hash) && res[:record]  
       r = Result.new(res)        
       description = r.description || ""
      
       result_hash = {}
       result_hash[:job_title] = r.job_title if r.job_title
       result_hash[:summary] = r.summary if r.summary
       result_hash[:branch_phone] = r.branch_phone if r.branch_phone
       result_hash[:images] = r.images if r.images      
       @file.puts result_hash.to_yaml
    end    
  end

  def open_root_node(*args)
  end

  def close_root_node(*args)
  end
end