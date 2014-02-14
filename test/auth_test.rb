require "minitest/autorun"

class TestAuth < Minitest::Test
  def setup
    @expected_cid = "99999999-1F7E-11E1-B760-000000000000"
    @expected_secret_key = "8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M=="
    @expected_resource = "/foo/bar/baz/"
  end

  def test_headers_are_set_on_get
    RubyTelesign::Auth.generate_auth_headers(
            @expected_cid,
            @expected_secret_key,
            @expected_resource,
            "GET")
  end

  def test_nonce_is_set
    expected_nonce = "1234"
    # double needed
    random_mock.return_value = expected_nonce

    headers = telesign.api.generate_auth_headers(
            @expected_cid,
            @expected_secret_key,
            @expected_resource,
            "GET")

    assert_equal headers["x-ts-nonce"], expected_nonce
  end

  def test_date_is_set
    headers = telesign.api.generate_auth_headers(
                @expected_cid,
                @expected_secret_key,
                @expected_resource,
                "GET")

    # Can't mock datetime
    refute_match headers["x-ts-date"], nil
  end

  def test_sha1_default_auth_method
    expected_auth_method = "HMAC-SHA1"

    headers = telesign.api.generate_auth_headers(
                @expected_cid,
                @expected_secret_key,
                @expected_resource,
                "GET")

    assert_equal headers["x-ts-auth-method"], expected_auth_method, "Auth method did not match"
  end

  def test_sha256_auth_method
    expected_auth_method = "HMAC-SHA256"

    headers = telesign.api.generate_auth_headers(
                @expected_cid,
                @expected_secret_key,
                @expected_resource,
                "GET",
                "",
                "sha256")

    assert_equal headers["x-ts-auth-method"], expected_auth_method, "Auth method did not match"
  end

  def test_customer_id_in_auth
    expected_auth_start = "TSA %s:" % @expected_cid

    headers = telesign.api.generate_auth_headers(
                @expected_cid,
                @expected_secret_key,
                @expected_resource,
                "GET")

    assert_equal headers["Authorization"].startswith(expected_auth_start), "Authorization did not start with TSA and customer ID"
  end
end
