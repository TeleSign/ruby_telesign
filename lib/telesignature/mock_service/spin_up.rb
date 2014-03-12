module Telesignature
  module MockService
    module SpinUp
      if ENV['TELESIGN_STUBBED']
        port = (ENV['TELESIGN_PORT'].to_i || 11989)
        if `lsof -i :#{port}`.blank? # no process running on 11988
          Process.detach(pid = Process.fork do
            require 'telesignature/mock_service/fake_server'
          end)
        else
          Rails.logger.warn "TELESIGN STUB MODE FAILED TO START\nProcess already listening on #{port}"
        end
      end

      at_exit { pid && `kill #{pid}` }
    end
  end
end
