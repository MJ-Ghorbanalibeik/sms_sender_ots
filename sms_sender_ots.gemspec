$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sms_sender_ots/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sms_sender_ots"
  s.version     = SmsSenderOts::VERSION
  s.authors     = ["Mojtaba Ghorbanalibeik", "Hossein Bukhamseen"]
  s.email       = ["mojtaba.ghorbanalibeik@gmail.com", "bukhamseen.h@gmail.com"]
  s.homepage    = "https://github.com/MJ-Ghorbanalibeik/sms_sender_ots"
  s.summary     = "Send sms via otsdc.com"
  s.description = "Send sms via otsdc.com According to documentation: http://docs.unifonic.apiary.io"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "rails", "~> 4", ">= 4.2"
  s.add_development_dependency "webmock", "~> 1.24", ">= 1.24.6"
  s.add_development_dependency "dotenv", "~> 2.1", ">= 2.1.1"
end
