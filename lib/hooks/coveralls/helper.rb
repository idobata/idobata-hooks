module Idobata::Hook
  class Coveralls
    module Helper
      def two_places_of_float(covered_percent)
        sprintf('%.2f', covered_percent.to_f)
      end
    end
  end
end
