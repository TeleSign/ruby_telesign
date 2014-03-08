require 'faraday'
require 'json'

module Telesignature
  class ServiceBase
    # attr_accessor :customer_id, :secret_key, :api_host

    def initialize opts = {}
      @customer_id = opts[:customer_id]
      @secret_key = opts[:secret_key]
      api_host = opts[:api_host]
      ssl = opts[:ssl] || nil
      proxy_host = opts[:proxy_host] || nil

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
