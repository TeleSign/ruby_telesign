module Telesignature
  module Helpers
    def random_with_N_digits n
      range_start = 10 ** (n - 1)
      range_end = (10 ** n) - 1
      Random.new.rand(range_start...range_end)
    end

    def validate_response response
      resp_obj = JSON.load response.body
      if response.status != 200
        if response.status == 401
          raise AuthorizationError.new resp_obj, response
        else
          raise TelesignError.new resp_obj, response
        end
      end

      resp_obj
    end
  end
end
