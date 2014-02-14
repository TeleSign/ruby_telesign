# Authorization header definitions

require 'securerandom'
require 'base64'

# __author__ = "Jeremy Cunningham, Michael Fox, and Radu Maierean"
# __copyright__ = "Copyright 2012, TeleSign Corp."
# __credits__ = ["Jeremy Cunningham", "Radu Maierean", "Michael Fox", "Nancy Vitug", "Humberto Morales"]
# __license__ = "MIT"
# __maintainer__ = "Jeremy Cunningham"
# __email__ = "support@telesign.com"
# __status__ = ""


AUTH_METHOD = {
    sha1: {hash: 'sha1', name: 'HMAC-SHA1'},
    sha256: {hash: 'sha256', name: 'HMAC-SHA256'}
}

module Auth
  def generate_auth_headers(
          customer_id,
          secret_key,
          resource,
          method,
          content_type='',
          auth_method=:sha1, fields=None)

      current_date = Time.mktime(*Time.now.to_a).to_s
      nonce = SecureRandom.uuid

      if %w(POST PUT).include? method
        content_type = "application/x-www-form-urlencoded"
      end

      string_to_sign = "%s\n%s\n\nx-ts-auth-method:%s\nx-ts-date:%s\nx-ts-nonce:%s" % [
              method,
              content_type,
              AUTH_METHOD[auth_method]["name"],
              current_date,
              nonce]

      if fields
        string_to_sign += "\n%s" % urllib.urlencode fields
      end

      string_to_sign += "\n%s" % resource

      digest = OpenSSL::Digest.new AUTH_METHOD[auth_method][:hash]
      signer = OpenSSL::HMAC.digest digest, Base64.decode64(secret_key), string_to_sign

      signature = Base64.encode64 signer.digest

      {
        "Authorization": "TSA %s:%s" % [customer_id, signature],
        "x-ts-date": current_date,
        "x-ts-auth-method": AUTH_METHOD[auth_method][:namex],
        "x-ts-nonce": nonce
      }
  end
end
