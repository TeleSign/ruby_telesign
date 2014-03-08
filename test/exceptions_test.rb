require 'minitest/autorun'
require 'pry'
require 'telesignature'

class ExceptionTestTest < Minitest::Test
  # Test for exceptions in telesign sdk
  def setup
    @expected_errors = [{code: 1, description: 'Error 1'},
                        {code: 2, description: 'Error 2'}]
    @expected_headers = {a: 'AA', b: 'BB'}
    @expected_status = '200'
    @expected_data = 'abcdefg'

    @expected_http_response = Hash.new
    @expected_http_response[:headers] = @expected_headers
    @expected_http_response[:status_code] = @expected_status
    @expected_http_response[:text] = @expected_data
  end


  def validate_exception_properties x
    assert_equal x.errors, @expected_errors, 'Errors property was not set on exception'
    assert_equal x.headers, @expected_headers, 'Headers property was not set on exception'
    assert_equal x.status, @expected_status, 'Status property was not set on exception'
    assert_equal x.data, @expected_data, 'Data property was not set on exception'
    assert_equal x.raw_data, @expected_data, 'RawData property was not set on exception'

    msg = x.message
    @expected_errors.each do |err|
      assert_match err[:description], msg
    end
  end

  def test_properties_are_populated_in_TelesignError
    begin
      raise Telesignature::TelesignError.new( @expected_errors, @expected_http_response )
    rescue Telesignature::TelesignError => x
      validate_exception_properties x
    end
  end

  def test_properties_are_populated_in_AuthorizationError
    begin
      raise Telesignature::AuthorizationError.new @expected_errors, @expected_http_response
    rescue Telesignature::AuthorizationError => x
      validate_exception_properties x
    end
  end

  def test_properties_are_populated_in_ValidationError
    begin
      raise Telesignature::ValidationError.new @expected_errors, @expected_http_response
    rescue Telesignature::ValidationError => x
      validate_exception_properties(x)
    end
  end
end
