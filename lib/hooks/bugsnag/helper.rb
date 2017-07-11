module Idobata::Hook
  class Bugsnag < Base
    module Helper
      def type_to_label(type)
        case type
        when 'firstException', 'exception'
          'Error'
        else
          type.titleize
        end
      end
    end
  end
end
