# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telesignature/version'

Gem::Specification.new do |spec|
  spec.name          = 'telesignature'
  spec.version       = Telesignature::VERSION
  spec.authors       = ['Andy Koch']
  spec.email         = ['akoch@practicefusion.com']
  spec.description   = %q{Client gem for Telesign REST API}
  spec.summary       = %q{Client gem for Telesign REST API}
  spec.homepage      = 'https://github.com/practicefusion/telesignature'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-debugger'
  spec.add_development_dependency 'mimic'
end
