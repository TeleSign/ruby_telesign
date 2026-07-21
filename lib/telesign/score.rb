require 'telesign/rest'

DETECT_HOST = 'https://detect.telesign.com'
INTELLIGENCE_RESOURCE = '/intelligence/phone'
EMAIL_INTELLIGENCE_RESOURCE = '/intelligence/email'

module Telesign

  # Obtain a risk recommendation for a phone number using TeleSign Intelligence Cloud API.
  # Supports POST /intelligence/phone endpoint (Cloud migration).
  # Sends phone number and parameters in request body as form-urlencoded.
  # See https://developer.telesign.com/enterprise/reference/submitphonenumberforintelligencecloud for detailed API documentation.
  class ScoreClient < RestClient

    def initialize(customer_id, api_key, rest_endpoint: DETECT_HOST, **kwargs)
      super(customer_id, api_key, rest_endpoint: rest_endpoint, **kwargs)
    end

    # Required parameters:
    #   - phone_number
    #   - account_lifecycle_event ("create", "sign-in", "transact", "update", "delete")
    # Optional parameters: account_id, device_id, email_address, external_id, originating_ip, etc.
    def score(phone_number, account_lifecycle_event, **params)
      raise ArgumentError, 'phone_number cannot be null or empty' if phone_number.nil? || phone_number.empty?
      raise ArgumentError, 'account_lifecycle_event cannot be null or empty' if account_lifecycle_event.nil? || account_lifecycle_event.empty?

      params[:phone_number] = phone_number
      params[:account_lifecycle_event] = account_lifecycle_event 

      self.post(INTELLIGENCE_RESOURCE, **params)
    end

    def email_intelligence(email_address, account_lifecycle_event, **params)
      # Obtain a risk recommendation for this email address, as well as
      # other relevant information using Email Intelligence API.
      #
      # Required parameters:
      # - email_address
      # - account_lifecycle_event ("create", "sign-in", "transact", "update", "delete")

      if email_address.nil? || email_address.to_s.strip.empty?
        raise ArgumentError, "email_address cannot be null or empty"
      end

      if account_lifecycle_event.nil? || account_lifecycle_event.to_s.strip.empty?
        raise ArgumentError, "account_lifecycle_event cannot be null or empty"
      end

      email_address = email_address.to_s.strip.downcase
      account_lifecycle_event = account_lifecycle_event.to_s.strip.downcase

      params[:email_address] = email_address
      params[:account_lifecycle_event] = account_lifecycle_event

      post(EMAIL_INTELLIGENCE_RESOURCE, **params)
    end
  end
end
