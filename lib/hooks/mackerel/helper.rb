module Idobata::Hook
  class Mackerel
    module Helper
      def label_class_from_build_status(status)
        case status
        when 'ok'
          'label-success'
        when 'critical'
          'label-important'
        when 'warning'
          'label-warning'
        else
          nil
        end
      end
    end
  end
end
