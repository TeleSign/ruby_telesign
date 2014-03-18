module Telesignature
  class AuthorizationError < TelesignError
    # """
    # Either the client failed to authenticate with the REST API server, or the service cannot be executed using the specified credentials.

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
