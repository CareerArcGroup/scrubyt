require 'rubygems'
require Dir[File.join(File.dirname(__FILE__)+'/scrubyt/functions.rb')][0]
Dir[File.join(File.dirname(__FILE__)+'/scrubyt/*.rb')].each { |lib| require lib }
Dir[File.join(File.dirname(__FILE__)+'/scrubyt/export/*.rb')].each { |lib| require lib }