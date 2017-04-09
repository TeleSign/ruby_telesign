require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
account_lifecycle_event = 'create'

score_client = Telesign::ScoreClient.new(customer_id, secret_key)
response = score_client.score(phone_number, account_lifecycle_event)

if response.ok
    puts "Phone number %s has a '%s' risk level and the recommendation is to '%s' the transaction." %
        [phone_number,
        response.json['risk']['level'],
        response.json['risk']['recommendation']]
end
