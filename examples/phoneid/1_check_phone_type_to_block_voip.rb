require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

phone_number = 'phone_number'
phone_type_voip = '5'

phoneid_client = Telesign::PhoneIdClient.new(customer_id, api_key)
response = phoneid_client.phoneid(phone_number)

if response.ok
    if response.json['phone_type']['code'] == phone_type_voip
        puts "Phone number #{phone_number} is a VOIP phone."
    else
        puts "Phone number #{phone_number} is not a VOIP phone."
    end
end
