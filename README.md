telesign
=============

Ruby TeleSign SDK

example
=============
```ruby
require 'telesignature'

customer_id = 'FFFFFFFF-EEEE-DDDD-1234-AB1234567890'
secret_key = 'EXAMPLE----TE8sTgg45yusumoN6BYsBVkh+yRJ5czgsnCehZaOYldPJdmFh6NeX8kunZ2zU1YWaUw/0wV6xfw=='
phone_number = '4445551212'

require 'telesignature'

ta = Telesignature::Api.new customer_id: customer_id,
                            secret_key: secret_key

phone_info = ta.phone_id.standard phone_number

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p "##################"

phone_info = ta.phone_id.contact phone_number, 'PWRT'

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p "##################"

phone_info = ta.phone_id.score phone_number, 'PWRT'

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p "##################"

begin
  phone_info = ta.phone_id.live phone_number, 'RXPF'
rescue Telesignature::AuthorizationError => e
  puts e.message
end

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p "##################"

phone_info = ta.verify.sms phone_number: phone_number #, verify_code: '12345'

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p phone_info.verify_code
p "##################"

status_info = ta.verify.status phone_info.data['reference_id'], phone_info.verify_code
# status_info = ta.verify.status phone_info.data['reference_id'], '12345'

p "\n\n\n"
p "##################"
p status_info.data
p status_info.headers
p status_info.status
p status_info.raw_data
p status_info.verify_code
p "##################"
```

stubs mode
=============
If you're running this in a Rails app, there is a stubs mode Sinatra app available.

Enable it by setting ENV['TELESIGN_STUBBED'] to something truthy.

The Sinatra app will run on "http://localhost:11989".

Currently stubs mode supports:

post '/v1/verify/sms'
post '/v1/verify/call'

Both of which always return a success response.

get '/v1/verify/:reference_id'

Returns VALID for any verify_code which does not contain '666'.

get '/v1/phoneid/standard/:phone_number'

See codes for triggering different phone-type responses.
