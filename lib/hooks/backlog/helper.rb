module Idobata::Hook
  class Backlog < Base
    module Helper
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
