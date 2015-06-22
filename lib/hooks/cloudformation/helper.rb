module Idobata::Hook
  class Cloudformation
    module Helper
      def message
        payload['Message'].gsub(/\n(?=')/, '').split("\n").map{ |s|
          s.match(/\A(.+)='(.+)'\z/).to_a.drop(1)
        }.to_h
      end

      def label_type(status)
        case status
        when 'CREATE_COMPLETE', 'UPDATE_COMPLETE', 'UPDATE_ROLLBACK_COMPLETE'
          'success'
        when 'CREATE_IN_PROGRESS', 'DELETE_IN_PROGRESS',
             'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS', 'UPDATE_IN_PROGRESS'
          'warning'
        when 'CREATE_FAILED', 'DELETE_FAILED', 'ROLLBACK_COMPLETE', 'ROLLBACK_FAILED',
             'ROLLBACK_IN_PROGRESS', 'UPDATE_FAILED', 'UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS',
             'UPDATE_ROLLBACK_FAILED', 'UPDATE_ROLLBACK_IN_PROGRESS'
          'danger'
        when 'DELETE_COMPLETE'
          'default'
        end
      end
    end
  end
end
