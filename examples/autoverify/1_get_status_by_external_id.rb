require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

external_id = 'external_id'

av_client = Telesign::AutoVerifyClient.new(customer_id, api_key)
response = av_client.status(external_id)

if response.ok
    puts 'AutoVerify transaction with external_id %s has status code %s and status description %s.' %
        [external_id,
        response.json['status']['code'],
        response.json['status']['description']]
end
