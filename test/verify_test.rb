require 'minitest/autorun'
require 'pry'
require 'telesignature'
require 'webmock/minitest'

class VerifyTest < Minitest::Test
  # Test for Verify telesign sdk

  def setup
    @expected_cid = '99999999-1F7E-11E1-B760-000000000000'
    @expected_secret_key = '8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M=='
    @expected_phone_no = '12343455678'
    @expected_language = 'en'
    @expected_verify_code = '54321'
    @expected_ref_id = '99999999999999999'
    @expected_data = '{ "a":"AA", "b":"BB" }'
    @expected_sms_resource = 'https://rest.telesign.com/v1/verify/sms'
    @expected_call_resource = 'https://rest.telesign.com/v1/verify/call'
    @expected_status_resource = "https://rest.telesign.com/v1/verify/%s" % @expected_ref_id
    @proxy = 'localhost:8080'
    @expected_proxy = 'https://localhost:8080'

    @acceptance_headers = { 'Accept' => /.*/,
                            'Accept-Encoding' => /.*/,
                            'Authorization' => /.*/,
                            'User-Agent' => /.*/,
                            'X-Ts-Auth-Method' => /.*/,
                            'X-Ts-Date'=> /.*/,
                            'X-Ts-Nonce' => /.*/,
                            'Content-Type'=>'application/x-www-form-urlencoded'}
  end

  def test_verify_sms
    fields = {phone_number:  @expected_phone_no,
              language: @expected_language,
              verify_code: @expected_verify_code,
              template: ''}

    stub_request(:post, @expected_sms_resource).
      with( body: fields,
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.sms phone_number: @expected_phone_no,
             verify_code: @expected_verify_code,
             language: @expected_language
  end

  def test_setting_ssl_false
    fields = {phone_number:  @expected_phone_no,
              language: @expected_language,
              verify_code: @expected_verify_code,
              template: ''}

    stub_request(:post, 'http://rest.telesign.com/v1/verify/sms').
      with( body: fields,
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid,
                                     secret_key: @expected_secret_key,
                                     ssl: false

    tele.verify.sms phone_number: @expected_phone_no,
             verify_code: @expected_verify_code,
             language: @expected_language
  end

  def test_verify_call
    fields = {phone_number:  @expected_phone_no,
              language: @expected_language,
              verify_code: @expected_verify_code}

    stub_request(:post, @expected_call_resource).
      with( body: fields,
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.call phone_number: @expected_phone_no,
              verify_code: @expected_verify_code,
              language: @expected_language
  end

  def test_verify_sms_default_code
    fields = {phone_number:  @expected_phone_no,
              language: @expected_language,
              verify_code: /\d{5}/,
              template: ''}

    stub_request(:post, @expected_sms_resource).
      with( body: fields,
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.sms phone_number: @expected_phone_no,
             language: @expected_language
  end

  def test_verify_call_default_code
    fields = {phone_number:  @expected_phone_no,
              language: @expected_language,
              verify_code: /\d{5}/}

    stub_request(:post, @expected_call_resource).
      with( body: fields,
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.call phone_number: @expected_phone_no,
              language: @expected_language
  end

  def test_status_check
    @acceptance_headers.delete('Content-Type')
    stub_request(:get, @expected_status_resource).
      with( headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.status @expected_ref_id
  end

  def test_report_code
    @acceptance_headers.delete('Content-Type')
    stub_request(:get, @expected_status_resource).
      with( query: {verify_code: @expected_verify_code.to_s},
            headers: @acceptance_headers).
        to_return(body: @expected_data, status: 200)

    tele = Telesignature::Api.new customer_id: @expected_cid, secret_key: @expected_secret_key
    tele.verify.status @expected_ref_id, @expected_verify_code
  end

  # # @mock.patch.object(requests, "post")
  # def test_verify_sms_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = Verify.new(@expected_cid, @expected_secret_key, proxy_host="localhost:8080")
  #   p.sms(@expected_phone_no, @expected_verify_code, @expected_language)

  #   assert_true req_mock.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs['url'], @expected_sms_resource, "Sms verify resource was incorrect"
  #   assert_equal kwargs["data"]["phone_number"], @expected_phone_no, "Phone number field did not match"
  #   assert_equal kwargs["data"]["language"], @expected_language, "Language field did not match"
  #   assert_equal kwargs["data"]["verify_code"], @expected_verify_code, "Verify code field did not match"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "post")
  # def test_verify_call_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = Verify.new(@expected_cid, @expected_secret_key, proxy_host=@proxy)
  #   p.call(@expected_phone_no, @expected_verify_code, @expected_language)

  #   assert_true req_mock.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs['url'], @expected_call_resource, "Call verify resource was incorrect"
  #   assert_equal kwargs["data"]["phone_number"], @expected_phone_no, "Phone number field did not match"
  #   assert_equal kwargs["data"]["language"], @expected_language, "Language field did not match"
  #   assert_equal kwargs["data"]["verify_code"], @expected_verify_code, "Verify code field did not match"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "get")
  # def test_status_check_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = Verify.new(@expected_cid, @expected_secret_key, proxy_host=@proxy)
  #   p.status(@expected_ref_id)

  #   assert_true req_mock.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_status_resource, "Status resource was incorrect"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end

  # # @mock.patch.object(requests, "get")
  # def test_report_code_with_proxy
  #   response = mock.Mock()
  #   response.reason = ""
  #   response.status_code = 200
  #   response.text = @expected_data
  #   req_mock.return_value = response

  #   p = Verify.new(@expected_cid, @expected_secret_key, proxy_host=@proxy)
  #   p.status(@expected_ref_id, @expected_verify_code)

  #   assert_true req_mock.called
  #   _, kwargs = req_mock.call_args
  #   assert_equal kwargs["url"], @expected_status_resource, "Status resource was incorrect"
  #   assert_equal kwargs["params"]["verify_code"], @expected_verify_code, "Verify code did not match"
  #   assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  # end
end

