module Idobata::Hook
  class Backlog < Base
    module Helper
      def type_label
        case payload.type
        when 1
          label = 'created'
        when 2
          label = 'updated'
        when 3
          label = 'commented'
        when 4
          label = 'issue deleted'
        when 17
          label = 'noticed'
        when 14
          label = 'multiple issues updated'
        end
        label
      end

      def backlog_url_base
        "https://#{space_id}.backlog.jp/view/#{payload.project.projectKey}" if space_id
      end

      def backlog_urls
        urls = []
        if backlog_url_base
          if payload.content.key_id
            url  = "#{backlog_url_base}-#{payload.content.key_id}"
            url += "#comment-#{payload.content.comment.id}" if payload.content.comment && payload.content.comment.id
            urls << url
          else
            payload.content.link.each do |link|
              urls << "#{backlog_url_base}-#{link.key_id}" if link.key_id
            end
          end
        end
        urls
      end

      def md(source)
        HTML::Pipeline::MarkdownFilter.new(source, gfm: true).call.to_s.html_safe
      end

      def hbr(source)
        html_escape(source).gsub(/\r\n|\r|\n/, "<br />").html_safe
      end
    end
  end
end
