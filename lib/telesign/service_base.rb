require 'faraday'
require 'json'

module Telesign
  class ServiceBase
    # attr_accessor :customer_id, :secret_key, :api_host

    def initialize api_host, customer_id, secret_key, ssl=true, proxy_host=nil
      @customer_id = customer_id
      @secret_key = secret_key
      @api_host = api_host

      http_root = ssl ? 'https' : 'http'
      proxy = proxy_host ? "#{http_root}://#{proxy_host}" : nil
      url = "#{http_root}://#{api_host}"

      @conn = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def validate_response response
      resp_obj = JSON.load response.body
      if response.status != 200
        if response.status == 401
          raise AuthorizationError.new resp_obj, response
        else
          raise TelesignError.new resp_obj, response
        end
      end

      resp_obj
    end
  end
end
