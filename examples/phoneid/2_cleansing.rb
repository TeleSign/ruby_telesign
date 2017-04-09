require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

extra_digit = '0'
phone_number = 'phone_number'
incorrect_phone_number = "#{phone_number}#{extra_digit}"

phoneid_client = Telesign::PhoneIdClient.new(customer_id, secret_key)
response = phoneid_client.phoneid(incorrect_phone_number)

if response.ok
    puts 'Cleansed phone number has country code %s and phone number is %s.' %
        [response.json['numbering']['cleansing']['call']['country_code'],
        response.json['numbering']['cleansing']['call']['phone_number']]

    puts 'Original phone number was %s.' %
        [response.json['numbering']['original']['complete_phone_number']]
end
