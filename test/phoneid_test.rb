require "minitest/autorun"


class PhoneIdTest < Minitest::Test
  # Test for phone id telesign sdk

  def setup
    @expected_cid = "99999999-1F7E-11E1-B760-000000000000"
    @expected_secret_key = "8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M=="
    @expected_phone_no = "12343455678"
    @expected_data = "{ \"a\": \"AA\", \"b\":\"BB\" }"
    @expected_resource = "https://rest.telesign.com/v1/phoneid/%s/%s"
    @proxy = "localhost:8080"
    @expected_proxy = "https://localhost:8080"
  end


  # @mock.patch.object(requests, "get")
  def test_standard_phoneid req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)
    p.standard(@expected_phone_no)

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['standard', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_standard_phoneid_unauthorized req_mock
    response = mock.Mock()
    response.reason = "Unauthorized"
    response.status_code = 401
    response.text = "{ \"a\": \"AA\", \"b\":\"BB\", \"errors\": { \"code\": \"401\", \"description\":\"Unauthorized\" } }"
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)

    with assert_raises telesign.exceptions.AuthorizationError
      p.standard(@expected_phone_no)

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['standard', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_standard_phoneid_other_error req_mock
    response = mock.Mock()
    response.reason = "Bad Gateway"
    response.status_code = 502
    response.text = "{ \"a\": \"AA\", \"b\":\"BB\", \"errors\": { \"code\": \"502\", \"description\":\"Bad Gateway\" } }"
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)

    assert_raises TelesignError { p.standard(@expected_phone_no) }

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['standard', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_score_phoneid req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)
    p.score(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['score', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_contact_phoneid req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)
    p.contact(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['contact', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_live_phoneid req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key)
    p.live(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['live', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_false kwargs['proxies']
  end

  # @mock.patch.object(requests, "get")
  def test_standard_phoneid_with_proxy req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
    p.standard(@expected_phone_no)

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['standard', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  end

  # @mock.patch.object(requests, "get")
  def test_score_phoneid_with_proxy req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
    p.score(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['score', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  end

  # @mock.patch.object(requests, "get")
  def test_contact_phoneid_with_proxy req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key, @proxy)
    p.contact(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['contact', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  end

  # @mock.patch.object(requests, "get")
  def test_live_phoneid_with_proxy req_mock
    response = mock.Mock()
    response.reason = ""
    response.status_code = 200
    response.text = @expected_data
    req_mock.return_value = response

    p = PhoneId.new(@expected_cid, @expected_secret_key, proxy_host=@proxy)
    p.live(@expected_phone_no, 'OTHR')

    assert_true req_mock.called
    _, kwargs = req_mock.call_args
    assert_equal kwargs["url"], @expected_resource % ['live', @expected_phone_no], "Phone ID resource name is incorrect"
    assert_equal kwargs["proxies"]["https"], @expected_proxy, "Proxy did not match"
  end
end
