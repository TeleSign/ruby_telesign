require 'telesign/version'

module Telesign
  autoload :API, 'telesign/api'
  autoload :Auth, 'telesign/auth'
  autoload :TelesignError, 'telesign/telesign_error'
  autoload :AuthorizationError, 'telesign/authorization_error'
  autoload :ValidationError, 'telesign/validation_error'
end
