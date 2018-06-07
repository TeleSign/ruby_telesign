require 'helper'

class TestRest < Test::Unit::TestCase

  def setup
    @customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
    @api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
  end

  def test_rest_client_constructors
    client = Telesign::RestClient.new(@customer_id,
                                      @api_key,
                                      rest_endpoint: 'http://localhost')
  end

  def test_generate_telesign_headers_with_post

    method_name = 'POST'
    date_rfc2616 = 'Wed, 14 Dec 2016 18:20:12 GMT'
    nonce = 'A1592C6F-E384-4CDB-BC42-C3AB970369E9'
    resource = '/v1/resource'
    body_params_url_encoded = 'test=param'

    expected_authorization_header = 'TSA FFFFFFFF-EEEE-DDDD-1234-AB1234567890:' +
        '2xVlmbrxLjYrrPun3G3WMNG6Jon4yKcTeOoK9DjXJ/Q='
    content_type = "application/x-www-form-urlencoded"

    actual_headers = Telesign::RestClient.generate_telesign_headers(@customer_id,
                                                                    @api_key,
                                                                    method_name,
                                                                    resource,
                                                                    content_type,
                                                                    body_params_url_encoded,
                                                                    date_rfc2616: date_rfc2616,
                                                                    nonce: nonce,
                                                                    user_agent: 'unit_test')

    assert_equal(expected_authorization_header, actual_headers['Authorization'],
                 'Authorization header is not as expected')
  end

  def test_generate_telesign_headers_unicode_content

    method_name = 'POST'
    date_rfc2616 = 'Wed, 14 Dec 2016 18:20:12 GMT'
    nonce = 'A1592C6F-E384-4CDB-BC42-C3AB970369E9'
    resource = '/v1/resource'
    body_params_url_encoded = 'test=%CF%BF'

    expected_authorization_header = 'TSA FFFFFFFF-EEEE-DDDD-1234-AB1234567890:' +
        'h8d4I0RTxErbxYXuzCOtNqb/f0w3Ck8e5SEkGNj01+8='
    content_type = "application/x-www-form-urlencoded"

    actual_headers = Telesign::RestClient.generate_telesign_headers(@customer_id,
                                                                    @api_key,
                                                                    method_name,
                                                                    resource,
                                                                    content_type,
                                                                    body_params_url_encoded,
                                                                    date_rfc2616: date_rfc2616,
                                                                    nonce: nonce,
                                                                    user_agent: 'unit_test')

    assert_equal(expected_authorization_header, actual_headers['Authorization'],
                 'Authorization header is not as expected')
  end

  def test_generate_telesign_headers_with_get

    method_name = 'GET'
    date_rfc2616 = 'Wed, 14 Dec 2016 18:20:12 GMT'
    nonce = 'A1592C6F-E384-4CDB-BC42-C3AB970369E9'
    resource = '/v1/resource'
    body_params_url_encoded = 'test=%CF%BF'

    expected_authorization_header = 'TSA FFFFFFFF-EEEE-DDDD-1234-AB1234567890:' +
        'aUm7I+9GKl3ww7PNeeJntCT0iS7b+EmRKEE4LnRzChQ='
    content_type = "application/x-www-form-urlencoded"

    actual_headers = Telesign::RestClient.generate_telesign_headers(@customer_id,
                                                                    @api_key,
                                                                    method_name,
                                                                    resource,
                                                                    content_type,
                                                                    body_params_url_encoded,
                                                                    date_rfc2616: date_rfc2616,
                                                                    nonce: nonce,
                                                                    user_agent: 'unit_test')

    assert_equal(expected_authorization_header, actual_headers['Authorization'],
                 'Authorization header is not as expected')
  end

  def test_generate_telesign_headers_with_default_values

    method_name = 'GET'
    resource = '/v1/resource'

    expected_authorization_header = 'TSA FFFFFFFF-EEEE-DDDD-1234-AB1234567890:' +
        'aUm7I+9GKl3ww7PNeeJntCT0iS7b+EmRKEE4LnRzChQ='
    content_type = "application/x-www-form-urlencoded"

    actual_headers = Telesign::RestClient.generate_telesign_headers(@customer_id,
                                                                    @api_key,
                                                                    method_name,
                                                                    content_type,
                                                                    resource,
                                                                    '')

    assert_not_nil(UUID.validate(actual_headers['x-ts-nonce']), 'x-ts-nonce header is not a valid UUID')

    assert_nothing_raised do
      Time.httpdate(actual_headers['Date'])
    end
  end

  def test_rest_client_post

    test_resource = '/test/resource'
    test_params = {:'test' => "123_\u03ff_test"}

    stub_request(:post, 'localhost/test/resource').to_return(body: '{}')

    client = Telesign::RestClient.new(@customer_id,
                                      @api_key,
                                      rest_endpoint: 'http://localhost')

    client.post(test_resource, **test_params)

    assert_requested :post, 'http://localhost/test/resource'
    assert_requested :post, 'http://localhost/test/resource', body: 'test=123_%CF%BF_test'
    assert_requested :post, 'http://localhost/test/resource', headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    assert_requested :post, 'http://localhost/test/resource', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :post, 'http://localhost/test/resource', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :post, 'http://localhost/test/resource', headers: {'Date' => /.*\S.*/}
  end

  def test_rest_client_get

    test_resource = '/test/resource'
    test_params = {:'test' => "123_\u03ff_test"}

    stub_request(:get, 'localhost/test/resource').to_return(body: '{}')

    client = Telesign::RestClient.new(@customer_id,
                                      @api_key,
                                      rest_endpoint: 'http://localhost')

    client.get(test_resource, **test_params)


    assert_requested :get, 'http://localhost/test/resource'
    # webmock doesn't seem to track query params...?
    # assert_requested :get, 'http://localhost/test/resource', query: {'test' => '123_%CF%BF_test'}
    assert_requested :get, 'http://localhost/test/resource', body: ''
    assert_not_requested :get, 'http://localhost/test/resource', headers: {'Content-Type' => /.*\S.*/}
    assert_requested :get, 'http://localhost/test/resource', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :get, 'http://localhost/test/resource', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :get, 'http://localhost/test/resource', headers: {'Date' => /.*\S.*/}
  end

  def test_rest_client_put

    test_resource = '/test/resource'
    test_params = {:'test' => "123_\u03ff_test"}

    stub_request(:put, 'localhost/test/resource').to_return(body: '{}')

    client = Telesign::RestClient.new(@customer_id,
                                      @api_key,
                                      rest_endpoint: 'http://localhost')

    client.put(test_resource, **test_params)

    assert_requested :put, 'http://localhost/test/resource'
    assert_requested :put, 'http://localhost/test/resource', body: 'test=123_%CF%BF_test'
    assert_requested :put, 'http://localhost/test/resource', headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    assert_requested :put, 'http://localhost/test/resource', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :put, 'http://localhost/test/resource', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :put, 'http://localhost/test/resource', headers: {'Date' => /.*\S.*/}
  end

  def test_rest_client_delete

    test_resource = '/test/resource'
    test_params = {:'test' => "123_\u03ff_test"}

    stub_request(:delete, 'localhost/test/resource').to_return(body: '{}')

    client = Telesign::RestClient.new(@customer_id,
                                      @api_key,
                                      rest_endpoint: 'http://localhost')

    client.delete(test_resource, **test_params)

    assert_requested :delete, 'http://localhost/test/resource'
    # webmock doesn't seem to track query params...?
    # assert_requested :get, 'http://localhost/test/resource', query: {'test' => '123_%CF%BF_test'}
    assert_requested :delete, 'http://localhost/test/resource', body: ''
    assert_not_requested :delete, 'http://localhost/test/resource', headers: {'Content-Type' => /.*\S.*/}
    assert_requested :delete, 'http://localhost/test/resource', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :delete, 'http://localhost/test/resource', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :delete, 'http://localhost/test/resource', headers: {'Date' => /.*\S.*/}
  end

  def test_phoneid
    stub_request(:post, 'localhost/v1/phoneid/1234567890').to_return(body: '{}')

    client = Telesign::PhoneIdClient::new(@customer_id,
                                          @api_key,
                                          rest_endpoint: 'http://localhost')
    client.phoneid('1234567890')
    
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890'
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', body: '{}'
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'Content-Type' => 'application/json'}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'Date' => /.*\S.*/}
  end

  def test_phoneid_with_addons
    stub_request(:post, 'localhost/v1/phoneid/1234567890').to_return(body: '{}')

    client = Telesign::PhoneIdClient::new(@customer_id,
                                          @api_key,
                                          rest_endpoint: 'http://localhost')
    client.phoneid('1234567890', addons: {'contact': {}})

    assert_requested :post, 'http://localhost/v1/phoneid/1234567890'
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', body: '{"addons":{"contact":{}}}'
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'Content-Type' => 'application/json'}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :post, 'http://localhost/v1/phoneid/1234567890', headers: {'Date' => /.*\S.*/}
  end
end
