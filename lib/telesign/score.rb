require 'telesign/rest'

SCORE_RESOURCE = '/v1/score/%{phone_number}'

module Telesign

  # Score provides risk information about a specified phone number.
  class ScoreClient < RestClient

    # Score is an API that delivers reputation scoring based on phone number intelligence, traffic patterns, machine
    # learning, and a global data consortium.
    #
    # See https://developer.telesign.com/docs/rest_api-phoneid-score for detailed API documentation.
    def score(phone_number, account_lifecycle_event, **params)

      self.post(SCORE_RESOURCE % {:phone_number => phone_number},
                account_lifecycle_event: account_lifecycle_event,
                **params)
    end
  end
end
