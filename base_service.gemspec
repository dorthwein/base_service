$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_service"
  s.version     = BaseService::VERSION
  s.authors     = ["Daniel Orthwein", "DFO Enterprises, LLC"]
  s.email       = ["dorthwein@gmail.com"]
  s.homepage    = "http://www.theorthweins.com"
  s.summary     = "A handy gem"
  s.description = "Creates a nifty BaseService class"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

end
