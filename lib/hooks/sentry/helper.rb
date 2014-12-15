module Idobata::Hook
  class Sentry
    module Helper
      def label_class_from_level(level)
        case level
        when 'fatal', 'error'
          'label-important'
        when 'warning'
          'label-warning'
        when 'info', 'debug'
          'label-info'
        else
          nil
        end
      end
    end
  end
end
