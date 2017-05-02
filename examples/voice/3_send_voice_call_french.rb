# encoding: UTF-8
require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

phone_number = 'phone_number'

message = 'N\'oubliez pas d\'appeler votre mère pour son anniversaire demain.'
message_type = 'ARN'

voice_client = Telesign::VoiceClient.new(customer_id, api_key)
response = voice_client.call(phone_number, message, message_type, voice: 'f-FR-fr')
