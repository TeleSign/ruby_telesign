Gem::Specification.new do |s|
  s.name                    = 'telesign'
  s.version                 = '2.2.5'
  s.licenses                = ['MIT']
  s.date                    = '2017-05-25'
  s.summary                 = 'TeleSign Ruby SDK'
  s.description             = 'TeleSign Ruby SDK'
  s.authors                 = ['TeleSign']
  s.email                   = 'support@telesign.com'
  s.files                   = Dir['lib/**/*rb']
  s.homepage                = 'http://rubygems.org/gems/telesign'

  s.add_runtime_dependency 'net-http-persistent', '>= 3.0.0', '< 5.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'uuid'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'codecov'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'test-unit'
end