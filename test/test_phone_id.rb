require 'helper'
class TestPhoneId < Test::Unit::TestCase
  def setup
    @customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
    @api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
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