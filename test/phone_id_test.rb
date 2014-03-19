require 'minitest/autorun'
require 'pry'
require 'telesignature'
require 'webmock/minitest'


class PhoneIdTest < Minitest::Test
  # Test for phone id telesign sdk

  def setup
    @expected_cid = '99999999-1F7E-11E1-B760-000000000000'
    @expected_secret_key = '8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M=='
    @expected_phone_no = '12343455678'
    @expected_data = '{ "a":"AA", "b":"BB" }'
    @expected_resource = "https://rest.telesign.com/v1/phoneid/%s/%s"
    @proxy = 'localhost:8080'
    @expected_proxy = 'https://localhost:8080'

    @acceptance_headers = { 'Accept' => /.*/,
                            'Accept-Encoding' => /.*/,
                            'Authorization' => /.*/,
                            'User-Agent' => /.*/,
                            'X-Ts-Auth-Method' => /.*/,
                            'X-Ts-Date'=> /.*/,
                            'X-Ts-Nonce' => /.*/}
  end

  def test_standard_phoneid
    stub_request(:get, @expected_resource % ['standard', @expected_phone_no]).
      with( headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.phone_id.standard @expected_phone_no
  end

  def test_standard_phoneid_unauthorized
    response_body = '{ "a":"AA", "b":"BB", "errors": { "code":"401", "description":"Unauthorized" } }'

    stub_request(:get, @expected_resource % ['standard', @expected_phone_no]).
      with( headers: @acceptance_headers).
        to_return(body: response_body, status: [401, 'Unauthorized'])

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key

    assert_raises(Telesignature::AuthorizationError){
      tele.phone_id.standard(@expected_phone_no)
    }
  end

  def test_standard_phoneid_other_error
    response_body = '{ "a":"AA", "b":"BB", "errors": { "code":"502", "description":"Bad Gateway" } }'

    stub_request(:get, @expected_resource % ['standard', @expected_phone_no]).
      with( headers: @acceptance_headers).
        to_return(body: response_body, status: [502, 'Bad Gateway'])

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key

    assert_raises(Telesignature::TelesignError){
      tele.phone_id.standard(@expected_phone_no)
    }
  end

  def test_score_phoneid
    stub_request(:get, @expected_resource % ['score', @expected_phone_no]).
      with(query: {ucid: 'OTHR'}, headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.phone_id.score @expected_phone_no, 'OTHR'
  end

  def test_contact_phoneid
    stub_request(:get, @expected_resource % ['contact', @expected_phone_no]).
      with(query: {ucid: 'OTHR'}, headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.phone_id.contact @expected_phone_no, 'OTHR'
  end

  def test_live_phoneid
    stub_request(:get, @expected_resource % ['live', @expected_phone_no]).
      with(query: {ucid: 'OTHR'}, headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.phone_id.live @expected_phone_no, 'OTHR'
  end

  # # @mock.patch.object(requests, "get")
  # def test_standard_phoneid_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
  #   p.standard(@expected_phone_no)

  #   assert_true.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_resource % ['standard', @expected_phone_no], "Phone ID resource name is incorrect"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "get")
  # def test_score_phoneid_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
  #   p.score(@expected_phone_no, 'OTHR')

  #   assert_true.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_resource % ['score', @expected_phone_no], "Phone ID resource name is incorrect"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "get")
  # def test_contact_phoneid_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
  #   p.contact(@expected_phone_no, 'OTHR')

  #   assert_true.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_resource % ['contact', @expected_phone_no], "Phone ID resource name is incorrect"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "get")
  # def test_live_phoneid_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = PhoneId.new(@expected_cid, @expected_secret_key, proxy_host=@proxy)
  #   p.live(@expected_phone_no, 'OTHR')

  #   assert_true.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_resource % ['live', @expected_phone_no], "Phone ID resource name is incorrect"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end
end
