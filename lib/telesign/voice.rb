require 'telesign/rest'

VOICE_RESOURCE = '/v1/voice'
VOICE_STATUS_RESOURCE = '/v1/voice/%{reference_id}'

module Telesign

  # TeleSign's Voice API allows you to easily send voice messages. You can send alerts, reminders, and notifications,
  # or you can send verification messages containing time-based, one-time passcodes (TOTP).
  class VoiceClient < RestClient

    # Send a voice call to the target phone_number.
    #
    # See https://developer.telesign.com/docs/voice-api for detailed API documentation.
    def call(phone_number, message, message_type, **params)

      self.post(VOICE_RESOURCE,
                phone_number: phone_number,
                message: message,
                message_type: message_type,
                **params)
    end

    # Retrieves the current status of the voice call.
    #
    # See https://developer.telesign.com/docs/voice-api for detailed API documentation.
    def status(reference_id, **params)

      self.get(VOICE_STATUS_RESOURCE % {:reference_id => reference_id},
               **params)
    end
  end
end
