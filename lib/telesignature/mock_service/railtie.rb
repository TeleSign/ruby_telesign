module Telesignature
  module MockService
    class Railtie < ::Rails::Railtie
      initializer 'telesignature_railtie.configure_rails_initialization' do
        if ENV['TELESIGN_STUBBED']
          Process.detach(Process.fork do
            require 'telesignature/mock_service/fake_server'
          end)
        end
      end
    end
  end
end
