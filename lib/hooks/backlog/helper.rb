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
        "https://#{space_id}.backlog.jp/view/" if space_id
      end

      def issue_link(summary, key_id, comment=nil)
        issue_key = "#{payload.project.projectKey}-#{key_id}" if key_id

        if backlog_url_base && issue_key
          url  = "#{backlog_url_base}#{issue_key}"
          url += "#comment-#{comment.id}" if comment.try(:id)

          anker = render_as_haml("%a{href: url}= summary", url: url, summary: summary) if summary
        end

        anker || summary || issue_key
      end

      def render_as_haml(haml, locals)
        Haml::Engine.new(haml, escape_html: true).render(self, locals)
      end

      def hbr(source)
        html_escape(source).gsub(/\r\n|\r|\n/, "<br />").html_safe
      end
    end
  end
end
