module Idobata::Hook
  class Pagerduty
    module Helper
      def label_type(status)
        case status
        when 'triggered'
          'danger'
        when 'resolved'
          'success'
        else
          'info'
        end
      end
    end
  end
end
