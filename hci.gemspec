# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hci/version"

Gem::Specification.new do |s|
  s.name        = "hci"
  s.version     = Hci::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sam Oliver"]
  s.email       = ["sam@samoliver.com"]
  s.homepage    = ""
  s.summary     = %q{HCI client}
  s.description = %q{HCI is a service and simple API for human intelligence tasks}

  s.rubyforge_project = "hci"
  
  s.add_dependency "rest-client"
  s.add_dependency "json"
  s.add_development_dependency "rspec", ">= 1.2.9"
  s.add_development_dependency "webmock"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
