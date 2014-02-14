# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_telesign/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_telesign"
  spec.version       = RubyTelesign::VERSION
  spec.authors       = ["Andy Koch"]
  spec.email         = ["akoch@practicefusion.com"]
  spec.description   = %q{Client gem for Telesign REST API}
  spec.summary       = %q{Client gem for Telesign REST API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
