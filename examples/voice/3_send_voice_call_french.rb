# encoding: UTF-8
require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'

message = 'N\'oubliez pas d\'appeler votre mère pour son anniversaire demain.'
message_type = 'ARN'

voice_client = Telesign::VoiceClient.new(customer_id, secret_key)
response = voice_client.call(phone_number, message, message_type, voice: 'f-FR-fr')
