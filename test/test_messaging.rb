require 'helper'

class TestMessaging < Test::Unit::TestCase

  def setup
    @customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
    @api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
    @client = Telesign::MessagingClient.new(@customer_id,
                                            @api_key,
                                            rest_endpoint: 'http://localhost')
  end

  def test_message
    stub_request(:post, 'localhost/v1/messaging').to_return(body: '{}')

    @client.message('1234567890', 'hello world', 'ARN', message_tag: 'promo')

    assert_requested :post, 'http://localhost/v1/messaging'
    assert_requested :post, 'http://localhost/v1/messaging', body: 'phone_number=1234567890&message=hello+world&message_type=ARN&message_tag=promo'
    assert_requested :post, 'http://localhost/v1/messaging', headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    assert_requested :post, 'http://localhost/v1/messaging', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :post, 'http://localhost/v1/messaging', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :post, 'http://localhost/v1/messaging', headers: {'Date' => /.*\S.*/}
  end

  def test_status
    stub_request(:get, 'localhost/v1/messaging/ABC123?verify=true').to_return(body: '{}')

    @client.status('ABC123', verify: true)

    assert_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true'
    assert_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true', body: ''
    assert_not_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true', headers: {'Content-Type' => /.*\S.*/}
    assert_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :get, 'http://localhost/v1/messaging/ABC123?verify=true', headers: {'Date' => /.*\S.*/}
  end
end