require 'pp'
require 'json'
require 'time'
require 'base64'
require 'openssl'
require 'securerandom'
require 'net/http/persistent'

module Telesign
  SDK_VERSION = '2.1.2'

  # The TeleSign RestClient is a generic HTTP REST client that can be extended to make requests against any of
  # TeleSign's REST API endpoints.
  #
  # RequestEncodingMixin offers the function _encode_params for url encoding the body for use in string_to_sign outside
  # of a regular HTTP request.
  #
  # See https://developer.telesign.com for detailed API documentation.
  class RestClient

    @user_agent = "TeleSignSDK/ruby-{#{SDK_VERSION} #{RUBY_DESCRIPTION} net/http/persistent"

    # A simple HTTP Response object to abstract the underlying net/http library response.

    # * +http_response+ - A net/http response object.
    class Response

      attr_accessor :status_code, :headers, :body, :ok, :json

      def initialize(http_response)
        @status_code = http_response.code
        @headers = http_response.to_hash
        @body = http_response.body
        @ok = http_response.kind_of? Net::HTTPSuccess

        begin
          @json = JSON.parse(http_response.body)
        rescue JSON::JSONError
          @json = nil
        end
      end
    end

    # TeleSign RestClient, useful for making generic RESTful requests against the API.
    #
    # * +customer_id+ - Your customer_id string associated with your account.
    # * +api_key+ - Your api_key string associated with your account.
    # * +rest_endpoint+ - (optional) Override the default rest_endpoint to target another endpoint.
    # * +timeout+ - (optional) How long to wait for the server to send data before giving up, as a float.
    def initialize(customer_id,
                   api_key,
                   rest_endpoint: 'https://rest-api.telesign.com',
                   proxy: nil,
                   timeout: 10)

      @customer_id = customer_id
      @api_key = api_key
      @rest_endpoint = rest_endpoint

      @http = Net::HTTP::Persistent.new(name: 'telesign', proxy: proxy)

      unless timeout.nil?
        @http.open_timeout = timeout
        @http.read_timeout = timeout
      end
    end

    # Generates the TeleSign REST API headers used to authenticate requests.
    #
    # Creates the canonicalized string_to_sign and generates the HMAC signature. This is used to authenticate requests
    # against the TeleSign REST API.
    #
    # See https://developer.telesign.com/docs/authentication for detailed API documentation.
    #
    # * +customer_id+ - Your account customer_id.
    # * +api_key+ - Your account api_key.
    # * +method_name+ - The HTTP method name of the request as a upper case string, should be one of 'POST', 'GET',
    #   'PUT' or 'DELETE'.
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +url_encoded_fields+ - HTTP body parameters to perform the HTTP request with, must be a urlencoded string.
    # * +date_rfc2616+ - The date and time of the request formatted in rfc 2616, as a string.
    # * +nonce+ - A unique cryptographic nonce for the request, as a string.
    # * +user_agent+ - (optional) User Agent associated with the request, as a string.
    def self.generate_telesign_headers(customer_id,
                                       api_key,
                                       method_name,
                                       resource,
                                       url_encoded_fields,
                                       date_rfc2616: nil,
                                       nonce: nil,
                                       user_agent: nil)

      if date_rfc2616.nil?
        date_rfc2616 = Time.now.httpdate
      end

      if nonce.nil?
        nonce = SecureRandom.uuid
      end

      content_type = (%w[POST PUT].include? method_name) ? 'application/x-www-form-urlencoded' : ''

      auth_method = 'HMAC-SHA256'

      string_to_sign = "#{method_name}"

      string_to_sign << "\n#{content_type}"

      string_to_sign << "\n#{date_rfc2616}"

      string_to_sign << "\nx-ts-auth-method:#{auth_method}"

      string_to_sign << "\nx-ts-nonce:#{nonce}"

      if !content_type.empty? and !url_encoded_fields.empty?
        string_to_sign << "\n#{url_encoded_fields}"
      end

      string_to_sign << "\n#{resource}"

      digest = OpenSSL::Digest.new('sha256')
      key = Base64.decode64(api_key)

      signature = Base64.encode64(OpenSSL::HMAC.digest(digest, key, string_to_sign)).strip

      authorization = "TSA #{customer_id}:#{signature}"

      headers = {
          'Authorization'=>authorization,
          'Date'=>date_rfc2616,
          'x-ts-auth-method'=>auth_method,
          'x-ts-nonce'=>nonce
      }

      unless user_agent.nil?
        headers['User-Agent'] = user_agent
      end

      headers

    end

    # Generic TeleSign REST API POST handler.
    #
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +params+ - Body params to perform the POST request with, as a hash.
    def post(resource, **params)

      execute(Net::HTTP::Post, 'POST', resource, **params)

    end

    # Generic TeleSign REST API GET handler.
    #
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +params+ - Body params to perform the GET request with, as a hash.
    def get(resource, **params)

      execute(Net::HTTP::Get, 'GET', resource, **params)

    end

    # Generic TeleSign REST API PUT handler.
    #
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +params+ - Body params to perform the PUT request with, as a hash.
    def put(resource, **params)

      execute(Net::HTTP::Put, 'PUT', resource, **params)

    end

    # Generic TeleSign REST API DELETE handler.
    #
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +params+ - Body params to perform the DELETE request with, as a hash.
    def delete(resource, **params)

      execute(Net::HTTP::Delete, 'DELETE', resource, **params)

    end

    private
    # Generic TeleSign REST API request handler.
    #
    # * +method_function+ - The net/http request to perform the request.
    # * +method_name+ - The HTTP method name, as an upper case string.
    # * +resource+ - The partial resource URI to perform the request against, as a string.
    # * +params+ - Body params to perform the HTTP request with, as a hash.
    def execute(method_function, method_name, resource, **params)

      resource_uri = URI.parse("#{@rest_endpoint}#{resource}")

      url_encoded_fields = URI.encode_www_form(params, Encoding::UTF_8)

      headers = RestClient.generate_telesign_headers(@customer_id,
                                                     @api_key,
                                                     method_name,
                                                     resource,
                                                     url_encoded_fields,
                                                     user_agent: @user_agent)

      request = method_function.new(resource_uri.request_uri)

      unless params.empty?
        if %w[POST PUT].include? method_name
          request.set_form_data(params)
        else
          resource_uri.query = url_encoded_fields
        end
      end

      headers.each do |k, v|
        request[k] = v
      end

      http_response = @http.request(resource_uri, request)

      Response.new(http_response)
    end
  end
end
