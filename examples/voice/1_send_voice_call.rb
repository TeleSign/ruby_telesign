require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
message = 'You\'re scheduled for a dentist appointment at 2:30PM.'
message_type = 'ARN'

voice_client = Telesign::VoiceClient.new(customer_id, secret_key)
response = voice_client.call(phone_number, message, message_type)
