require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

external_id = 'external_id'

av_client = Telesign::AutoVerifyClient.new(customer_id, secret_key)
response = av_client.status(external_id)

if response.ok
    puts 'AutoVerify transaction with external_id %s has status code %s and status description %s.' %
        [external_id,
        response.json['status']['code'],
        response.json['status']['description']]
end
