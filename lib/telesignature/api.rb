require 'faraday'
require 'json'

module Telesignature
  class Api
    #    * - Attributes
    #      -
    #    * - `customer_id`
    #      - A string value that identifies your TeleSign account.
    #    * - `secret_key`
    #      - A base64-encoded string value that validates your access to the TeleSign web services.
    #    * - `ssl`
    #      - Specifies whether to use a secure connection with the TeleSign server. Defaults to *true*.
    #    * - `api_host`
    #      - The Internet host used in the base URI for REST web services.
    #         The default is *rest.telesign.com* (and the base URI is https://rest.telesign.com/).
    #    * - `proxy_host`
    #      - The host and port when going through a proxy server. ex: "localhost:8080. The default to no proxy.

    # NOTE
    #    You can obtain both your Customer ID and Secret Key from the
    #    TeleSign Customer Portal <https://portal.telesign.com/account_profile_api_auth.php>

    # """

    attr_accessor :verify, :phone_id

    def initialize opts = {}
      @customer_id = opts[:customer_id]
      @secret_key = opts[:secret_key]
      api_host = opts[:api_host] || 'rest.telesign.com'
      ssl = opts[:ssl].nil? ? true : opts[:ssl]
      proxy_host = opts[:proxy_host] || nil

      http_root = ssl ? 'https' : 'http'
      proxy = proxy_host ? "#{http_root}://#{proxy_host}" : nil
      url = "#{http_root}://#{api_host}"

      @conn = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @verify = Verify.new(conn: @conn, customer_id: opts[:customer_id], secret_key: opts[:secret_key])
      @phone_id = PhoneId.new(conn: @conn, customer_id: opts[:customer_id], secret_key: opts[:secret_key])
    end

  end
end
