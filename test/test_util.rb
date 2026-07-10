require 'helper'

class TestUtil < Test::Unit::TestCase

  def test_verify_telesign_callback_signature
    api_key = Base64.strict_encode64('top_secret_key')
    json_str = '{"status":"delivered","reference_id":"ABC123"}'

    digest = OpenSSL::Digest.new('sha256')
    key = Base64.decode64(api_key)
    valid_signature = Base64.encode64(OpenSSL::HMAC.digest(digest, key, json_str)).strip

    first_char = valid_signature[0] == 'A' ? 'B' : 'A'
    invalid_signature = first_char + valid_signature[1..-1]

    util = Telesign::Util.new

    assert_equal true, util.verify_telesign_callback_signature(api_key, valid_signature, json_str)
    assert_equal false, util.verify_telesign_callback_signature(api_key, invalid_signature, json_str)
  end
end