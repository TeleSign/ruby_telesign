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
require 'mocha/test_unit'

require 'telesign'

module Test
  module Unit
    class TestCase
    end
  end
end
