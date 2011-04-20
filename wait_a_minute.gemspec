# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wait_a_minute/version"

Gem::Specification.new do |s|
  s.name        = "wait_a_minute"
  s.version     = WaitAMinute::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["George Schreiber"]
  s.email       = ["gy.schreiber@mobility.hu"]
  s.homepage    = ""
  s.summary     = %q{A very simple DOS (Denial-Of-Service) attack prevention gem}
  s.description = %q{By including this in your app, it can track requests per IP address and refuse processing the request if there were too many requests recently from the given IP address.}

  s.rubyforge_project = "wait_a_minute"

#  s.files         = `git ls-files`.split("\n")
#  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
#  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "2.1.0"
  s.add_dependency "rails", ">=3.0.1"
end
