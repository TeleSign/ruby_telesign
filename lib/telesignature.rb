require 'telesignature/version'
require 'telesignature/mock_service/railtie' if defined? Rails

module Telesignature
  autoload :TelesignError, 'telesignature/telesign_error'
  autoload :AuthorizationError, 'telesignature/authorization_error'
  autoload :ValidationError, 'telesignature/validation_error'
  autoload :Auth, 'telesignature/auth'
  autoload :Response, 'telesignature/response'
  autoload :Helpers, 'telesignature/helpers'
  autoload :ServiceBase, 'telesignature/service_base'
  autoload :Verify, 'telesignature/verify'
  autoload :PhoneId, 'telesignature/phone_id'
end
