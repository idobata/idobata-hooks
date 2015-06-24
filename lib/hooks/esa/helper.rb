module Idobata::Hook
  class Esa < Base
    module Helper
      def user_with_icon(user)
        render_as_haml(<<-HAML.strip_heredoc, user: user)
          %span
            = avatar_image_tag(user.icon.thumb_s.url)
          = user.screen_name
        HAML
      end

      def link_to_post(team, post, with_diff: false)
        render_as_haml(<<-HAML.strip_heredoc, post: post , with_diff: with_diff)
          %a{href: post.url} #{team.name}##{post.number}
          - if with_diff
            (
            %a{href: payload.post.diff_url}<> diff
            )
          %b= payload.post.name
        HAML
      end

      def md(source)
        HTML::Pipeline::MarkdownFilter.new(source, gfm: true).call.to_s.html_safe
      end
    end

    def render_as_haml(haml, locals)
      Haml::Engine.new(haml, escape_html: true).render(self, locals)
    end
  end
end
