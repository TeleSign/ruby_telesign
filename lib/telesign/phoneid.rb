require 'telesign/rest'

PHONEID_RESOURCE = '/v1/phoneid/%{phone_number}'

module Telesign

  # A set of APIs that deliver deep phone number data attributes that help optimize the end user
  # verification process and evaluate risk.
  class PhoneIdClient < RestClient

    # The PhoneID API provides a cleansed phone number, phone type, and telecom carrier information to determine the
    # best communication method - SMS or voice.
    #
    # See https://developer.telesign.com/docs/phoneid-api for detailed API documentation.
    def phoneid(phone_number, **params)

      self.post(PHONEID_RESOURCE % {:phone_number => phone_number},
                **params)
    end

    private
    def content_type
      "application/json"
    end
  end
end
