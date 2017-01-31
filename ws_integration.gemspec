$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ws_integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ws_integration"
  s.version     = WsIntegration::VERSION
  s.authors     = ["krzysztofgrzybowski"]
  s.email       = ["krzysztof.grzybowski@polcode.net"]
  s.homepage    = "https://github.com/krzysztofgrzybowski/ws_integration"
  s.summary     = "Rails application integration with Worksnaps"
  s.description = "Rails application integration with Worksnaps"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0.0"
end
