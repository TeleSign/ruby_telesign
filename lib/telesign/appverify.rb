require 'telesign/rest'

APPVERIFY_STATUS_RESOURCE = '/v1/mobile/verification/status/%{external_id}'

module Telesign

  # App Verify is a secure, lightweight SDK that integrates a frictionless user verification process into existing
  # native mobile applications.
  class AppVerifyClient < RestClient

    # Retrieves the verification result for an App Verify transaction by external_id. To ensure a secure verification
    # flow you must check the status using TeleSign's servers on your backend. Do not rely on the SDK alone to
    # indicate a successful verification.
    #
    # See https://developer.telesign.com/docs/app-verify-android-sdk-self#section-get-status-service or
    # https://developer.telesign.com/docs/app-verify-ios-sdk-self#section-get-status-service for detailed
    # API documentation.
    def status(external_id, **params)

      self.get(APPVERIFY_STATUS_RESOURCE % {:external_id => external_id},
               **params)
    end
  end
end
