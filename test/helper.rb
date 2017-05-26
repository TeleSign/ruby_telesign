require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'uuid'
require 'time'
require 'test/unit'
require 'webmock/test_unit'
require 'mocha/setup'

require 'telesign'

class Test::Unit::TestCase
end