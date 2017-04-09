require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
verify_code = Telesign::Util.random_with_n_digits(5)
message = "Your code is #{verify_code}"
message_type = 'OTP'

messaging_client = Telesign::MessagingClient.new(customer_id, secret_key)
response = messaging_client.message(phone_number, message, message_type)

print 'Please enter the verification code you were sent: '
user_entered_verify_code = gets.strip

if verify_code == user_entered_verify_code
    puts 'Your code is correct.'
else
    puts 'Your code is incorrect.'
end
