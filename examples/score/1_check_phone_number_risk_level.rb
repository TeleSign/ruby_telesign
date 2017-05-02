require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

phone_number = 'phone_number'
account_lifecycle_event = 'create'

score_client = Telesign::ScoreClient.new(customer_id, api_key)
response = score_client.score(phone_number, account_lifecycle_event)

if response.ok
    puts "Phone number %s has a '%s' risk level and the recommendation is to '%s' the transaction." %
        [phone_number,
        response.json['risk']['level'],
        response.json['risk']['recommendation']]
end
