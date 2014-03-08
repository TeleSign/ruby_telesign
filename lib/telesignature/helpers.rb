module Telesignature
  module Helpers
    def random_with_N_digits n
      range_start = 10 ** (n - 1)
      range_end = (10 ** n) - 1
      Random.new.rand(range_start...range_end)
    end
  end
end
