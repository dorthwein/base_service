$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_service"
  s.version     = BaseService::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of BaseService."
  s.description = "TODO: Description of BaseService."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.12"

  s.add_development_dependency "sqlite3"
end
