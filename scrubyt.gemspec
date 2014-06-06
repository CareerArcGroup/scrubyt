
# -*- encoding: utf-8 -*-
require File.expand_path("../lib/scrubyt/version", __FILE__)

Gem::Specification.new do |s|
  s.name  = 'scrubyt'
  s.date  = '2013-06-18'
  s.summary = "Scrubyt"
  s.version = Scrubyt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.description = "Scraping framework"
  s.authors = ["Peter"]
  s.email = 'pduffy@tweetmyjobs.com'
  s.homepage  = 'https://github.com/CareerArcGroup/scrubyt'

  #s.add_dependency "json"
  s.add_development_dependency "bundler", "~> 1.1.0"
  s.add_development_dependency 'rspec'
  s.add_development_dependency "simplecov"
  s.add_runtime_dependency "watir-webdriver", "0.6.2"


  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

end
