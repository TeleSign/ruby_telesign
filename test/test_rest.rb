require 'test/unit'
require_relative '../lib/telesign.rb'

class TestRest < Test::Unit::TestCase

  def test_version

    puts Telesign::SDK_VERSION
  end

end