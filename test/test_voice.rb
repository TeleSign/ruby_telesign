require 'helper'

class TestVoice < Test::Unit::TestCase

  def setup
    @customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
    @api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
    @client = Telesign::VoiceClient.new(@customer_id,
                                        @api_key,
                                        rest_endpoint: 'http://localhost')
  end

  def test_call
    stub_request(:post, 'localhost/v1/voice').to_return(body: '{}')

    @client.call('1234567890', 'hello world', 'OTP', voice: 'female')

    assert_requested :post, 'http://localhost/v1/voice'
    assert_requested :post, 'http://localhost/v1/voice', body: 'phone_number=1234567890&message=hello+world&message_type=OTP&voice=female'
    assert_requested :post, 'http://localhost/v1/voice', headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    assert_requested :post, 'http://localhost/v1/voice', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :post, 'http://localhost/v1/voice', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :post, 'http://localhost/v1/voice', headers: {'Date' => /.*\S.*/}
  end

  def test_status
    stub_request(:get, 'localhost/v1/voice/ABC123?verify=true').to_return(body: '{}')

    @client.status('ABC123', verify: true)

    assert_requested :get, 'http://localhost/v1/voice/ABC123?verify=true'
    assert_requested :get, 'http://localhost/v1/voice/ABC123?verify=true', body: ''
    assert_not_requested :get, 'http://localhost/v1/voice/ABC123?verify=true', headers: {'Content-Type' => /.*\S.*/}
    assert_requested :get, 'http://localhost/v1/voice/ABC123?verify=true', headers: {'x-ts-auth-method' => 'HMAC-SHA256'}
    assert_requested :get, 'http://localhost/v1/voice/ABC123?verify=true', headers: {'x-ts-nonce' => /.*\S.*/}
    assert_requested :get, 'http://localhost/v1/voice/ABC123?verify=true', headers: {'Date' => /.*\S.*/}
  end
end