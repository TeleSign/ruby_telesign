module Telesign
  class PhoneId < ServiceBase
    include Helpers
    # """
    # The **PhoneId** class exposes three services that each provide detailed information about a specified phone number.

    # .. list-table::
    #    :widths: 5 30
    #    :header-rows: 1

    #    * - Attributes
    #      -
    #    * - `customer_id`
    #      - A string value that identifies your TeleSign account.
    #    * - `secret_key`
    #      - A base64-encoded string value that validates your access to the TeleSign web services.
    #    * - `ssl`
    #      - Specifies whether to use a secure connection with the TeleSign server. Defaults to *true*.
    #    * - `api_host`
    #      - The Internet host used in the base URI for REST web services. The default is *rest.telesign.com* (and the base URI is https://rest.telesign.com/).
    #    * - `proxy_host`
    #      - The host and port when going through a proxy server. ex: "localhost:8080. The default to no proxy.

    # .. note::
    #    You can obtain both your Customer ID and Secret Key from the `TeleSign Customer Portal <https://portal.telesign.com/account_profile_api_auth.php>`_.
    # """

    def initialize customer_id, secret_key, ssl=true, api_host='rest.telesign.com', proxy_host=nil
      super(api_host, customer_id, secret_key, ssl, proxy_host)
    end

    def standard phone_number
      # """
      # Retrieves the standard set of details about the specified phone number. This includes the type of phone (e.g., land line or mobile), and it's approximate geographic location.

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.

      # **Example**::

      #     from telesign.api import PhoneId
      #     from telesign.exceptions import AuthorizationError, TelesignError

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

      # """
      resource = "/v1/phoneid/standard/%s" % phone_number
      method = 'GET'

      headers = Telesign::Auth.generate_auth_headers(
          @customer_id,
          @secret_key,
          resource,
          method)

      response = @conn.get do |req|
          req.url resource
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response
    end

    def score phone_number, use_case_code
      # """
      # Retrieves a score for the specified phone number. This ranks the phone number's "risk level" on a scale from 0 to 1000, so you can code your web application to handle particular use cases (e.g., to stop things like chargebacks, identity theft, fraud, and spam).

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # .. rubric:: Use-case Codes

      # The following table list the available use-case codes, and includes a description of each.

      # ========  =====================================
      # Code      Description
      # ========  =====================================
      # **BACS**  Prevent bulk account creation + spam.
      # **BACF**  Prevent bulk account creation + fraud.
      # **CHBK**  Prevent chargebacks.
      # **ATCK**  Prevent account takeover/compromise.
      # **LEAD**  Prevent false lead entry.
      # **RESV**  Prevent fake/missed reservations.
      # **PWRT**  Password reset.
      # **THEF**  Prevent identity theft.
      # **TELF**  Prevent telecom fraud.
      # **RXPF**  Prevent prescription fraud.
      # **OTHR**  Other.
      # **UNKN**  Unknown/prefer not to say.
      # ========  =====================================

      # **Example**::

      #     from telesign.api import PhoneId
      #     from telesign.exceptions import AuthorizationError, TelesignError

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

      # """
      resource = "/v1/phoneid/score/%s" % phone_number
      method = 'GET'

      headers = Telesign::Auth.generate_auth_headers(
          @customer_id,
          @secret_key,
          resource,
          method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response
    end

    def contact phone_number, use_case_code
      # """
      # In addition to the information retrieved by **standard**, this service provides the Name & Address associated with the specified phone number.

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # .. rubric:: Use-case Codes

      # The following table list the available use-case codes, and includes a description of each.

      # ========  =====================================
      # Code      Description
      # ========  =====================================
      # **BACS**  Prevent bulk account creation + spam.
      # **BACF**  Prevent bulk account creation + fraud.
      # **CHBK**  Prevent chargebacks.
      # **ATCK**  Prevent account takeover/compromise.
      # **LEAD**  Prevent false lead entry.
      # **RESV**  Prevent fake/missed reservations.
      # **PWRT**  Password reset.
      # **THEF**  Prevent identity theft.
      # **TELF**  Prevent telecom fraud.
      # **RXPF**  Prevent prescription fraud.
      # **OTHR**  Other.
      # **UNKN**  Unknown/prefer not to say.
      # ========  =====================================

      # **Example**::

      #     from telesign.api import PhoneId
      #     from telesign.exceptions import AuthorizationError, TelesignError

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

      # """
      resource = "/v1/phoneid/contact/%s" % phone_number
      method = 'GET'

      headers = Telesign::Auth.generate_auth_headers(
          @customer_id,
          @secret_key,
          resource,
          method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response
    end

    def live phone_number, use_case_code
      # """
      # In addition to the information retrieved by **standard**, this service provides actionable data associated with the specified phone number.

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number you want details about. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `use_case_code`
      #      - A four letter code used to specify a particular usage scenario for the web service.

      # .. rubric:: Use-case Codes

      # The following table list the available use-case codes, and includes a description of each.

      # ========  =====================================
      # Code      Description
      # ========  =====================================
      # **BACS**  Prevent bulk account creation + spam.
      # **BACF**  Prevent bulk account creation + fraud.
      # **CHBK**  Prevent chargebacks.
      # **ATCK**  Prevent account takeover/compromise.
      # **LEAD**  Prevent false lead entry.
      # **RESV**  Prevent fake/missed reservations.
      # **PWRT**  Password reset.
      # **THEF**  Prevent identity theft.
      # **TELF**  Prevent telecom fraud.
      # **RXPF**  Prevent prescription fraud.
      # **OTHR**  Other.
      # **UNKN**  Unknown/prefer not to say.
      # ========  =====================================

      # **Example**::

      #     from telesign.api import PhoneId
      #     from telesign.exceptions import AuthorizationError, TelesignError

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

      # """
      resource = "/v1/phoneid/live/%s" % phone_number
      method = 'GET'

      headers = Telesign::Auth.generate_auth_headers(
          @customer_id,
          @secret_key,
          resource,
          method)

      response = @conn.get do |req|
          req.url resource
          req.params[:ucid] = use_case_code
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response
    end
  end
end
