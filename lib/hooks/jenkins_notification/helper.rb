module Idobata::Hook
  class JenkinsNotification
    module Helper
      def label_class_from_build_status(status)
        case status
        when 'SUCCESS'
          'label-success'
        when 'FAILURE'
          'label-important'
        when 'UNSTABLE'
          'label-warning'
        else
          nil
        end
      end
    end
  end
end
