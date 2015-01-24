module Idobata::Hook
  class JenkinsNotification
    module Helper
      def label_class_from_build_status(status)
        case status
        when 'SUCCESS'
          'label-success'
        when 'FAILURE'
          'label-danger'
        when 'UNSTABLE'
          'label-warning'
        else
          'label-default'
        end
      end
    end
  end
end
