require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
message = 'You\'re scheduled for a dentist appointment at 2:30PM.'
message_type = 'ARN'

messaging_client = Telesign::MessagingClient.new(customer_id, secret_key)
response = messaging_client.message(phone_number, message, message_type)
