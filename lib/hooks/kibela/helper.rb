module Idobata::Hook
  class Kibela
    module Helper
      def title
        return payload[resource_type].title unless resource_type == "comment"
        payload.comment.blog&.title || payload.comment.wiki&.title
      end

      def url
        payload[resource_type].url
      end

      def resource_type
        payload.resource_type
      end

      def md(source)
        HTML::Pipeline::MarkdownFilter.new(source, gfm: true).call.to_s.html_safe
      end
    end
  end
end
