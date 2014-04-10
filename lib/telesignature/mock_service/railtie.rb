module Telesignature
  module MockService
    class Railtie < ::Rails::Railtie
      initializer 'telesignature_railtie.configure_rails_initialization' do
        require 'telesignature/mock_service/spin_up'
      end
    end
  end
end
