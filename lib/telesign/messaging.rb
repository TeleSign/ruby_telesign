require 'telesign/rest'

MESSAGING_RESOURCE = '/v1/messaging'
MESSAGING_STATUS_RESOURCE = '/v1/messaging/%{reference_id}'

module Telesign

  # TeleSign's Messaging API allows you to easily send SMS messages. You can send alerts, reminders, and notifications,
  # or you can send verification messages containing one-time passcodes (OTP).
  class MessagingClient < RestClient

    # Send an SMS message to the target phone number.
    #
    # See https://developer.telesign.com/docs/messaging-api for detailed API documentation.
    def message(phone_number, message, message_type, **params)

      self.post(MESSAGING_RESOURCE,
                phone_number: phone_number,
                message: message,
                message_type: message_type,
                **params)
    end

    # Retrieves the status of an SMS transaction.
    #
    # See https://developer.telesign.com/docs/messaging-api for detailed API documentation.
    def status(reference_id, **params)

      self.get(MESSAGING_STATUS_RESOURCE % {:reference_id => reference_id},
               **params)
    end
  end
end
