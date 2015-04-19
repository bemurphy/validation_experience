$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "validation_experience/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "validation_experience"
  s.version     = ValidationExperience::VERSION
  s.authors     = ["Brendon Murphy"]
  s.email       = ["xternal1+github@gmail.com"]
  s.homepage    = "https://github.com/bemurphy/validation_experience"
  s.summary     = "ValidationExperience is a gem for Rails that tracks model validation failures and reports on them."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0"

  s.add_development_dependency "sqlite3"
end
