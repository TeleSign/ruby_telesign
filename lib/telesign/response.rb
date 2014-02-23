module Telesign
  class Response
    # attr_accessor :data, :headers, :status_code, :raw_data, :verify_code

    def initialize data, http_response, verify_code=nil
      @data = data
      @headers = http_response.headers
      @status_code = http_response.status
      @raw_data = http_response.body
      @verify_code = verify_code
    end
  end
end
