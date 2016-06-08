module Idobata::Hook
  class Docbase < Base
    module Helper
      def link_to_post(post_title, post_url)
        capture_haml do
          haml_tag :a, post_title, href: post_url
        end
      end

      def link_to_user(team_domain, user_id, user_name)
        url = "https://#{team_domain}.docbase.io/users/#{user_id}"
        capture_haml do
          haml_tag :a, user_name, href: url
        end
      end

      def link_to_joined_team_or_group(name, message)
        url_first_index = message.index(/https:/)
        url = message[url_first_index..-1]
        capture_haml do
          haml_tag :a, name, href: url
        end
      end

      def md(source)
        HTML::Pipeline::MarkdownFilter.new(source, gfm: true).call.to_s.html_safe
      end
    end
  end
end
