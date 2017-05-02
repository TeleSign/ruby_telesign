require 'telesign'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
api_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='

extra_digit = '0'
phone_number = 'phone_number'
incorrect_phone_number = "#{phone_number}#{extra_digit}"

phoneid_client = Telesign::PhoneIdClient.new(customer_id, api_key)
response = phoneid_client.phoneid(incorrect_phone_number)

if response.ok
    puts 'Cleansed phone number has country code %s and phone number is %s.' %
        [response.json['numbering']['cleansing']['call']['country_code'],
        response.json['numbering']['cleansing']['call']['phone_number']]

    puts 'Original phone number was %s.' %
        [response.json['numbering']['original']['complete_phone_number']]
end
