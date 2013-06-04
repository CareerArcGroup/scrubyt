require 'rubygems'
require 'rspec'
Dir[File.join(File.dirname(__FILE__)+'/lib/*.rb')].sort.each { |lib| require lib }
