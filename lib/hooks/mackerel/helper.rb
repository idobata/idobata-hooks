module Idobata::Hook
  class Mackerel
    module Helper
      def label_class_from_build_status(status)
        case status
        when 'ok'
          'label-success'
        when 'critical'
          'label-danger'
        when 'warning'
          'label-warning'
        else
          'label-default'
        end
      end
    end
  end
end
