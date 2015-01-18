module Idobata::Hook
  class Sentry
    module Helper
      def label_class_from_level(level)
        case level
        when 'fatal', 'error'
          'label-danger'
        when 'warning'
          'label-warning'
        when 'info', 'debug'
          'label-info'
        else
          'label-default'
        end
      end
    end
  end
end
