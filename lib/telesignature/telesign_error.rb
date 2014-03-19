module Telesignature
  class TelesignError < ::StandardError
    # The **exceptions** base class.

    #    * - Attributes
    #      -
    #    * - `data`
    #      - The data returned by the service, in a dictionary form.
    #    * - `http_response`
    #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

    attr_accessor :errors, :headers, :status, :data

    def initialize response_json, http_response
      @errors = response_json['errors']
      @headers = http_response.headers
      @status = http_response.status
      @data = http_response.body
      super()
    end

    def to_s
      @errors.inject(''){|ret, x| ret += "#{x['description']}\n" }
    end
  end
end
