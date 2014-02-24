module Telesign
  class Response
    attr_accessor :data, :headers, :status, :raw_data, :verify_code

    def initialize data, http_response, verify_code=nil
      @data = data
      @headers = http_response.headers
      @status = http_response.status
      @raw_data = http_response.body
      @verify_code = verify_code
    end
  end
end
