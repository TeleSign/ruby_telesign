module Telesign
  class Verify < ServiceBase
    include Helpers
    # """
    # The **Verify** class exposes two services for sending users a verification token (a three to five-digit number). You can use this mechanism to simply test whether you can reach users at the phone number they supplied, or you can have them use the token to authenticate themselves with your web application.

    # This class also exposes a service that is used in conjunction with the first two services, in that it allows you to confirm the result of the authentication.

    # You can use this verification factor in combination with username & password to provide two-factor authentication for higher security.

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

    def sms opts = {}
      phone_number = opts[:phone_number]
      verify_code = opts[:verify_code]
      language = opts[:language] || 'en-US'
      template = opts[:template] || ''

      # """
      # Sends a text message containing the verification code, to the specified phone number (supported for mobile phones only).

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number to receive the text message. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `verify_code`
      #      - (optional) The verification code to send to the user. If omitted, TeleSign will automatically generate a random value for you.
      #    * - `language`
      #      - (optional) The written language used in the message. The default is English.
      #    * - `template`
      #      - (optional) A standard form for the text message. It must contain the token ``$$CODE$$``, which TeleSign auto-populates with the verification code.

      # **Example**::

      #     from telesign.api import Verify
      #     from telesign.exceptions import AuthorizationError, TelesignError

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"

      #     verify = Verify(cust_id, secret_key) # Instantiate a Verify object.

      #     try:
      #         phone_info = verify.sms(phone_number)
      #     except AuthorizationError as ex:
      #         # API authorization failed, the API response should tell you the reason
      #         ...
      #     except TelesignError as ex:
      #         # failed to execute the Verify service, check the API response for details
      #         ...

      #     # When the user inputs the validation code, you can verify that it matches the one that you sent.
      #     if (phone_info != None):
      #         try:
      #             status_info = verify.status(phone_info.data["reference_id"], verify_code=phone_info.verify_code)
      #         except AuthorizationError as ex:
      #             ...
      #         except TelesignError as ex:
      #             ...

      # """

      if verify_code.nil?
        verify_code = random_with_N_digits(5)
      end

      resource = '/v1/verify/sms'
      method = 'POST'

      fields = {
          phone_number: phone_number,
          language: language,
          verify_code: verify_code,
          template: template}

      headers = Telesign::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method,
          fields: fields)

      response = @conn.post do |req|
          req.url resource
          req.body = fields
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response, verify_code
    end

    def call opts = {}
      phone_number = opts[:phone_number]
      verify_code = opts[:verify_code]
      language = opts[:language] || 'en-US'

      # """
      # Calls the specified phone number, and using speech synthesis, speaks the verification code to the user.

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `phone_number`
      #      - The phone number to receive the text message. You must specify the phone number in its entirety. That is, it must begin with the country code, followed by the area code, and then by the local number. For example, you would specify the phone number (310) 555-1212 as 13105551212.
      #    * - `verify_code`
      #      - (optional) The verification code to send to the user. If omitted, TeleSign will automatically generate a random value for you.
      #    * - `language`
      #      - (optional) The written language used in the message. The default is English.


      # **Example**::

      #     from telesign.api import Verify
      #     from telesign.exceptions import AuthorizationError, TelesignError

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"

      #     verify = Verify(cust_id, secret_key) # Instantiate a Verify object.

      #     try:
      #         phone_info = verify.call(phone_number)
      #     except AuthorizationError as ex:
      #         # API authorization failed, the API response should tell you the reason
      #         ...
      #     except TelesignError as ex:
      #         # failed to execute the Verify service, check the API response for details
      #         ...

      #     # When the user inputs the validation code, you can verify that it matches the one that you sent.
      #     if (phone_info != None):
      #         try:
      #             status_info = verify.status(phone_info.data["reference_id"], verify_code=phone_info.verify_code)
      #         except AuthorizationError as ex:
      #             ...
      #         except TelesignError as ex:
      #             ...

      # """

      if verify_code.nil?
        verify_code = random_with_N_digits(5)
      end

      resource = '/v1/verify/call'
      method = 'POST'

      fields = {
          phone_number: phone_number,
          language: language,
          verify_code: verify_code}

      headers = Telesign::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method,
          fields: fields)

      response = @conn.post do |req|
          req.url resource
          req.body = fields
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response, verify_code
    end

    def status ref_id, verify_code=nil
      # """
      # Retrieves the verification result. You make this call in your web application after users complete the authentication transaction (using either a call or sms).

      # .. list-table::
      #    :widths: 5 30
      #    :header-rows: 1

      #    * - Parameters
      #      -
      #    * - `ref_id`
      #      - The Reference ID returned in the response from the TeleSign server, after you called either **call** or **sms**.
      #    * - `verify_code`
      #      - The verification code received from the user.

      # **Example**::

      #     from telesign.api import Verify
      #     from telesign.exceptions import AuthorizationError, TelesignError

      #     cust_id = "FFFFFFFF-EEEE-DDDD-1234-AB1234567890"
      #     secret_key = "EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=="
      #     phone_number = "13107409700"

      #     verify = Verify(cust_id, secret_key) # Instantiate a Verify object.

      #     phone_info = verify.sms(phone_number) # Send a text message that contains an auto-generated validation code, to the user.

      #     # When the user inputs the validation code, you can verify that it matches the one that you sent.
      #     if (phone_info != None):
      #         try:
      #             status_info = verify.status(phone_info.data["reference_id"], verify_code=phone_info.verify_code)
      #         except AuthorizationError as ex:
      #             ...
      #         except TelesignError as ex:
      #             ...

      # """

      resource = "/v1/verify/%s" % ref_id
      method = 'GET'

      headers = Telesign::Auth.generate_auth_headers(
          customer_id: @customer_id,
          secret_key: @secret_key,
          resource: resource,
          method: method)

      fields = nil
      if !verify_code.nil?
        fields = {verify_code: verify_code}
      end

      response = @conn.get do |req|
          req.url resource
          fields.each{|k,v| req.params[k] = v} if fields
          req.headers = headers
          # proxies=@proxy
      end

      return Telesign::Response.new validate_response(response), response
    end
  end
end
