require 'telesign'

customer_id = 'customer_id'
secret_key = 'secret_key'

phone_number = 'phone_number'
verify_code = Telesign::Util.random_with_n_digits(5)
verify_code_with_commas = verify_code.chars.join(', ')
message = "Hello, your code is #{verify_code_with_commas}. Once again, your code is #{verify_code_with_commas}. Goodbye."
message_type = 'OTP'

voice_client = Telesign::VoiceClient.new(customer_id, secret_key)
response = voice_client.call(phone_number, message, message_type)

print 'Please enter the verification code you were sent: '
user_entered_verify_code = gets.strip

if verify_code == user_entered_verify_code
    puts 'Your code is correct.'
else
    puts 'Your code is incorrect.'
end
