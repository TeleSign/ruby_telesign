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

verifier = Telesignature::Verify.new customer_id: customer_id,
                                     secret_key: secret_key

phone_info = verifier.sms phone_number: phone_number #, verify_code: '12345'

p "##################"
p phone_info.data
p phone_info.headers
p phone_info.status
p phone_info.raw_data
p phone_info.verify_code
p "##################"

status_info = verifier.status phone_info.data['reference_id'], phone_info.verify_code
# status_info = verifier.status phone_info.data['reference_id'], '12345'

p "\n\n\n"
p "##################"
p status_info.data
p status_info.headers
p status_info.status
p status_info.raw_data
p status_info.verify_code
p "##################"
```
