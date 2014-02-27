require 'minitest/autorun'
require 'pry'
require 'telesign'

class TestAuth < Minitest::Test
  def setup
    @expected_cid = '99999999-1F7E-11E1-B760-000000000000'
    @expected_secret_key = '8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M8M=='
    @expected_resource = '/foo/bar/baz/'
  end

  def test_headers_are_set_on_get
    Telesign::Auth.generate_auth_headers(
            customer_id: @expected_cid,
            secret_key: @expected_secret_key,
            resource: @expected_resource,
            method: 'GET')
  end

  def test_nonce_is_set
    expected_nonce = '1234'

    headers = SecureRandom.stub :uuid, expected_nonce do
      Telesign::Auth.generate_auth_headers(
        customer_id: @expected_cid,
        secret_key: @expected_secret_key,
        resource: @expected_resource,
        method: 'GET')
    end

    assert_equal headers['x-ts-nonce'], expected_nonce
  end

  def test_date_is_set
    headers = Telesign::Auth.generate_auth_headers(
                customer_id: @expected_cid,
                secret_key: @expected_secret_key,
                resource: @expected_resource,
                method: 'GET')

    # Can't mock datetime
    refute_match headers['x-ts-date'], nil
  end

  def test_sha1_default_auth_method
    expected_auth_method = 'HMAC-SHA1'

    headers = Telesign::Auth.generate_auth_headers(
                customer_id: @expected_cid,
                secret_key: @expected_secret_key,
                resource: @expected_resource,
                method: 'GET')

    assert_equal headers['x-ts-auth-method'], expected_auth_method, 'Auth method did not match'
  end

  def test_sha256_auth_method
    expected_auth_method = 'HMAC-SHA256'

    headers = Telesign::Auth.generate_auth_headers(
                customer_id: @expected_cid,
                secret_key: @expected_secret_key,
                resource: @expected_resource,
                method: 'GET',
                auth_method: :sha256)

    assert_equal headers['x-ts-auth-method'], expected_auth_method, 'Auth method did not match'
  end

  def test_customer_id_in_auth
    expected_auth_start = "TSA %s:" % @expected_cid

    headers = Telesign::Auth.generate_auth_headers(
                customer_id: @expected_cid,
                secret_key: @expected_secret_key,
                resource: @expected_resource,
                method: 'GET')

    assert_match /^#{expected_auth_start}/, headers['Authorization'], 'Authorization did not start with TSA and customer ID'
  end
end
