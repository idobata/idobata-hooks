module Idobata::Hook
  class Github
    module Helper
      GITHUB_URL = 'https://github.com/'

      filters = [
        ::HTML::Pipeline::MarkdownFilter,
        ::HTML::Pipeline::MentionFilter
      ]

      GITHUB_DEFAULT_LABEL_COLORS = {
        '84b6eb' => '1c2733',
        'bfe5bf' => '2a332a',
        'bfdadc' => '2c3233',
        'c7def8' => '282d33',
        'bfd4f2' => '282c33',
        'd4c5f9' => '2b2833',
        'fbca04' => '332900',
        'f7c6c7' => '332829',
        'fad8c7' => '332c28',
        'fef2c0' => '333026',
        'cccccc' => '333333',
        'e6e6e6' => '333333',
        'ffffff' => '333333',
        '159818' => 'ffffff',
        'fc2929' => 'ffffff',
        'cc317c' => 'ffffff',
        'e11d21' => 'ffffff',
        'eb6420' => 'ffffff',
        '009800' => 'ffffff',
        '006b75' => 'ffffff',
        '207de5' => 'ffffff',
        '0052cc' => 'ffffff',
        '5319e7' => 'ffffff'
      }

      def md(source)
        markdown_pipeline(source, base_url: GITHUB_URL)
      end

      def render_action(payload, suffix)
        case payload.action
        when 'labeled', 'unlabeled'
          render_labeled(payload)
        when 'assigned', 'unassigned'
          render_assigned(payload)
        when 'review_requested'
          render_review_request(payload)
        when 'review_request_removed'
          render_review_request_removed(payload)
        else
          action = payload.pull_request.try(:merged) ? 'merged' : payload.action # `payload.action` is 'closed' on merge.

          "#{action} #{suffix}"
        end
      end

      private

      def render_labeled(payload)
        render_as_haml(<<-'HAML'.strip_heredoc, payload: payload)
          = payload.action
          %span.label(style="background-color: ##{payload.label.color}; color: ##{label_fg_color(payload.label.color)};")= payload.label.name
          = payload.action == 'labeled' ? 'to' : 'from'
        HAML
      end

      def render_assigned(paylaod)
        render_as_haml(<<-HAML.strip_heredoc, payload: payload)
          = payload.action
          %span= avatar_image_tag payload.assignee.avatar_url
          %a{href: payload.assignee.html_url}= payload.assignee.login
          = payload.action == 'assigned' ? 'to' : 'from'
        HAML
      end

      def render_review_request(paylaod)
        render_as_haml(<<-HAML.strip_heredoc, payload: payload)
          requested
          %span= avatar_image_tag payload.requested_reviewer.avatar_url
          %a{href: payload.requested_reviewer.html_url}= payload.requested_reviewer.login
          to review
        HAML
      end

      def render_review_request_removed(paylaod)
        render_as_haml(<<-HAML.strip_heredoc, payload: payload)
          removed
          a review request for
          %span= avatar_image_tag payload.requested_reviewer.avatar_url
          %a{href: payload.requested_reviewer.html_url}= payload.requested_reviewer.login
        HAML
      end

      def render_as_haml(haml, locals)
        Haml::Engine.new(haml, escape_html: true).render(self, locals)
      end

      def label_class_from_build_status(state)
        case state
        when 'success'
          'label-success'
        when 'failure'
          'label-danger'
        else
          'label-default'
        end
      end

      def label_fg_color(bg_color)
        GITHUB_DEFAULT_LABEL_COLORS[bg_color] || obtain_label_fg_color(bg_color)
      end

      def obtain_label_fg_color(bg_color)
        lightness = Sass::Script::Color.from_hex(bg_color).lightness

        lightness >= 60 ? '333' : 'fff'
      end
    end
  end
end
