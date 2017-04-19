Gem::Specification.new do |s|
  s.name                    = 'telesign'
  s.version                 = '2.0.0'
  s.licenses                = ['MIT']
  s.date                    = '2017-02-26'
  s.summary                 = 'TeleSign Ruby SDK'
  s.description             = 'TeleSign Ruby SDK'
  s.authors                 = ['TeleSign']
  s.email                   = 'support@telesign.com'
  s.files                   = Dir['lib/**/*rb']
  s.homepage                = 'http://rubygems.org/gems/telesign'

  s.add_runtime_dependency 'net-http-persistent', '~> 3.0', '>= 3.0.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'codecov'
  s.add_development_dependency 'simplecov'
end