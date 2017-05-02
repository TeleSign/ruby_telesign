require 'base64'
require 'openssl'
require 'securerandom'

module Telesign
  class Util

    def self.random_with_n_digits(n)
      n.times.map { SecureRandom.random_number(10) }.join
    end

    # Verify that a callback was made by TeleSign and was not sent by a malicious client by verifying the signature.
    #
    # * +api_key+ - the TeleSign API api_key associated with your account.
    # * +signature+ - the TeleSign Authorization header value supplied in the callback, as a string.
    # * +json_str+ - the POST body text, that is, the JSON string sent by TeleSign describing the transaction status.
    def verify_telesign_callback_signature(api_key, signature, json_str)

      digest = OpenSSL::Digest.new('sha256')
      key = Base64.decode64(api_key)

      your_signature = Base64.encode64(OpenSSL::HMAC.digest(digest, key, json_str)).strip

      unless signature.length == your_signature.length
        return false
      end

      # avoid timing attack with constant time equality check
      signatures_equal = true
      signature.split('').zip(your_signature.split('')).each do |x, y|
        unless x == y
          signatures_equal = false
        end
      end

      signatures_equal
    end
  end
end
