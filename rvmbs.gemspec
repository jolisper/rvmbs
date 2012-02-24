# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rvmbs/version"

Gem::Specification.new do |s|
  s.name        = "rvmbs"
  s.version     = RVMBS::VERSION
  s.authors     = ["Jorge Luis Pérez"]
  s.email       = ["jolisper@gmail.com"]
  s.homepage    = "http://github.com/jolisper/rvmbs"
  s.summary     = %q{RVM Bootstrap}
  s.description = %q{Command to create a project directory with a configured .rvmrc file.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
