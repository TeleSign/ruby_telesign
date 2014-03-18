module Telesignature
  class ValidationError < TelesignError
    # """
    # The submitted data failed the intial validation, and the service was not executed.

    #    * - Attributes
    #      -
    #    * - `data`
    #      - The data returned by the service, in a dictionary form.
    #    * - `http_response`
    #      - The full HTTP Response object, including the HTTP status code, headers, and raw returned data.

    # """

    def initialize errors, http_response
      super
    end
  end
end
