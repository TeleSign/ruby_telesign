module Telesignature
  class TelesignError < ::StandardError
    # """
    # The **exceptions** base class.

    # .. list-table::
    #    :widths: 5 30
    #    :header-rows: 1

    #    * - Attributes
    #      -
    #    * - `data`
    #      - The data returned by the service, in a dictionary form.
    #    * - `http_response`
    #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

    # """

    attr_accessor :errors, :headers, :status, :data, :raw_data

    def initialize errors, http_response
      @errors = errors
      @headers = http_response.headers
      @status = http_response.status
      @data = http_response.body
      super()
    end

    def to_s
      @errors.first['description']
    end
  end
end
