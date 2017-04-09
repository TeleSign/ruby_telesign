require 'telesign/rest'

AUTOVERIFY_STATUS_RESOURCE = '/v1/mobile/verification/status/%{external_id}'

module Telesign

  # AutoVerify is a secure, lightweight SDK that integrates a frictionless user verification process into existing
  # native mobile applications.
  class AutoVerifyClient < RestClient

    # Retrieves the verification result for an AutoVerify transaction by external_id. To ensure a secure verification
    # flow you must check the status using TeleSign's servers on your backend. Do not rely on the SDK alone to
    # indicate a successful verification.
    #
    # See https://developer.telesign.com/docs/auto-verify-sdk#section-obtaining-verification-status for detailed API
    # documentation.
    def status(external_id, **params)

      self.get(AUTOVERIFY_STATUS_RESOURCE % {:external_id => external_id},
               **params)
    end
  end
end
