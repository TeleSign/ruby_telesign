module Telesignature
  class PhoneId
    include Helpers

    attr_accessor :conn, :customer_id, :secret_key

    def initialize opts = {}
      @conn = opts[:conn]
      @customer_id = opts[:customer_id]
      @secret_key = opts[:secret_key]
    end

    def standard phone_number
      # Retrieves the standard set of details about the specified phone number.
      # This includes the type of phone (e.g., land line or mobile),
      # and it's approximate geographic location.

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number
      #        in its entirety. That is, it must begin with the country code, followed by
      #        the area code, and then by the local number.
      #        For example, you would specify the phone number (310) 555-1212 as 13105551212.

      # **Example**::

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"

      #     phoneid = PhoneId(cust_id, secret_key) # Instantiate a PhoneId object.

      #     try:
      #         phone_info = phoneid.standard(phone_number)

      #     except AuthorizationError as ex:
      #         # API authorization failed. Check the API response for details.
      #         ...

      #     except TelesignError as ex:
      #         # Failed to completely execute the PhoneID service. Check the API response
      #         # for details. Data returned might be incomplete or invalid.
      #         ...

      resource = "/v1/phoneid/standard/%s" % phone_number
      method = 'GET'

      headers = Telesignature::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method)

      response = @conn.get do |req|
          req.url resource
          req.headers = headers
          # proxies=@proxy
      end

      return Telesignature::Response.new validate_response(response), response
    end

    def score phone_number, use_case_code
      # Retrieves a score for the specified phone number.
      # This ranks the phone number's "risk level" on a scale from 0 to 1000,
      # so you can code your web application to handle particular use cases
      # (e.g., to stop things like chargebacks, identity theft, fraud, and spam).

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety.
      #        That is, it must begin with the country code, followed by the area code, and then by the local number.
      #        For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # The following table list the available use-case codes, and includes a description of each.

      # http://docs.telesign.com/rest/content/xt/xt-use-case-codes.html#xref-use-case-codes

      # **Example**::

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"
      #     use_case_code = "ATCK"

      #     phoneid = PhoneId(cust_id, secret_key) # Instantiate a PhoneId object.

      #     try:
      #         score_info = phoneid.score(phone_number, use_case_code)
      #     except AuthorizationError as ex:
      #         ...
      #     except TelesignError as ex:
      #         ...

      resource = "/v1/phoneid/score/%s" % phone_number
      method = 'GET'

      headers = Telesignature::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesignature::Response.new validate_response(response), response
    end

    def contact phone_number, use_case_code
      # In addition to the information retrieved by **standard**,
      # this service provides the Name & Address associated with the specified phone number.

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # http://docs.telesign.com/rest/content/xt/xt-use-case-codes.html#xref-use-case-codes

      # **Example**::

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"
      #     use_case_code = "LEAD"

      #     phoneid = PhoneId(cust_id, secret_key) # Instantiate a PhoneId object.

      #     try:
      #         phone_info = phoneid.contact(phone_number, use_case_code)
      #     except AuthorizationError as ex:
      #         # API authorization failed, the API response should tell you the reason
      #         ...
      #     except TelesignError as ex:
      #         # failed to completely execute the PhoneID service, check the API response
      #         #    for details; data returned may be incomplete or not be valid
      #         ...

      resource = "/v1/phoneid/contact/%s" % phone_number
      method = 'GET'

      headers = Telesignature::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesignature::Response.new validate_response(response), response
    end

    def live phone_number, use_case_code
      # In addition to the information retrieved by **standard**,
      # this service provides actionable data associated with the specified phone number.

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety.
      #        That is, it must begin with the country code, followed by the area code,
      #        and then by the local number.
      #        For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # The following table list the available use-case codes, and includes a description of each.

      # http://docs.telesign.com/rest/content/xt/xt-use-case-codes.html#xref-use-case-codes

      # **Example**::

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"
      #     use_case_code = "RXPF"

      #     phoneid = PhoneId(cust_id, secret_key) # Instantiate a PhoneId object.

      #     try:
      #         phone_info = phoneid.live(phone_number, use_case_code)
      #     except AuthorizationError as ex:
      #         # API authorization failed, the API response should tell you the reason
      #         ...
      #     except TelesignError as ex:
      #         # failed to completely execute the PhoneID service, check the API response
      #         #    for details; data returned may be incomplete or not be valid
      #         ...

      resource = "/v1/phoneid/live/%s" % phone_number
      method = 'GET'

      headers = Telesignature::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesignature::Response.new validate_response(response), response
    end
  end
end
