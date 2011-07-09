# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-flow/version"

Gem::Specification.new do |s|
  s.name        = "knife-flow"
  s.version     = Knife::Flow::VERSION
  s.authors     = ["Johnlouis Petitbon", "Jacob Zimmerman", "Aaron Suggs"]
  s.email       = ["jpetitbon@mdsol.com"]
  s.homepage    = "https://github.com/mdsol/knife-flow"
  s.summary     = %q{A collection of Chef plugins for managing the migration of cookbooks to environments in different Opscode organizations.}
  s.description = %q{The main reason for having a workflow around the development and promotion of cookbooks is to ensure quality, reliability and administrative security of the process.}

  s.rubyforge_project = "knife-flow"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
