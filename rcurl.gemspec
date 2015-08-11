# coding: utf-8

lib = File.expand_path("../lib/", __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'rcurl/version'

Gem::Specification.new do |gem|
  gem.name          = "rcurl"
  gem.version       = Rcurl::VERSION
  gem.authors       = ["Lukasz Wojcik"]
  gem.email         = ["sonar0007@hotmail.com"]
  gem.summary       = %q{Gem to sends curl like requests with pretty output. }
  gem.description   = %q{Gem to sends curl like requests with pretty output. }
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]



  gem.add_development_dependency "bundler", "~> 1.7"
  gem.add_development_dependency "rake", "~> 10.0"
end
