module Idobata::Hook
  class Bugsnag < Base
    module Helper
      def md(source)
        HTML::Pipeline::MarkdownFilter.new(source, gfm: true).call.to_s.html_safe
      end

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
