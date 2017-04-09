require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
phone_type_voip = '5'

phoneid_client = Telesign::PhoneIdClient.new(customer_id, secret_key)
response = phoneid_client.phoneid(phone_number)

if response.ok
    if response.json['phone_type']['code'] == phone_type_voip
        puts "Phone number #{phone_number} is a VOIP phone."
    else
        puts "Phone number #{phone_number} is not a VOIP phone."
    end
end
