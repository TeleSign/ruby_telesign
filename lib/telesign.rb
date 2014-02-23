require 'telesign/version'

module Telesign
  autoload :TelesignError, 'telesign/telesign_error'
  autoload :AuthorizationError, 'telesign/authorization_error'
  autoload :ValidationError, 'telesign/validation_error'
  autoload :Auth, 'telesign/auth'
  autoload :Response, 'telesign/response'
  autoload :Helpers, 'telesign/helpers'
  autoload :ServiceBase, 'telesign/service_base'
  autoload :Verify, 'telesign/verify'
  autoload :PhoneId, 'telesign/phone_id'
end
