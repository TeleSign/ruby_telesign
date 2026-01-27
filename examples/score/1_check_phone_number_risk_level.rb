require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'ABC12345yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

phone_number = '11234567890'
account_lifecycle_event = 'create'

score_client = Telesign::ScoreClient.new(customer_id, api_key)
response = score_client.score(phone_number, account_lifecycle_event)

if response.ok
  puts format(
    "Phone number %s has a '%s' risk level and the recommendation is to '%s' the transaction.",
    phone_number,
    response.json['risk']['level'],
    response.json['risk']['recommendation']
  )
else
  puts "Request failed with status code: #{response.status_code}. Details: #{response.json}"
end
