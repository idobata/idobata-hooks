module Idobata::Hook
  class Github
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter,
        ::HTML::Pipeline::MentionFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true, base_url: 'https://github.com/')

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
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def render_action(payload, suffix)
        if labeled_action?(payload.action)
          render_labeled(payload)
        elsif assigned_action?(payload.action)
          render_assigned(payload)
        else
          action = payload.pull_request.try(:merged) ? 'merged' : payload.action # `payload.action` is 'closed' on merge.

          "#{action} #{suffix}"
        end
      end

      private

      def labeled_action?(action)
        %w(labeled unlabeled).include?(action)
      end

      def render_labeled(payload)
        render_as_haml(<<-'HAML'.strip_heredoc, payload: payload)
          = payload.action
          %span.label(style="background-color: ##{payload.label.color}; color: ##{label_fg_color(payload.label.color)};")= payload.label.name
          = payload.action == 'labeled' ? 'to' : 'from'
        HAML
      end

      def assigned_action?(action)
        %w(assigned unassigned).include?(payload.action)
      end

      def render_assigned(paylaod)
        render_as_haml(<<-HAML.strip_heredoc, payload: payload)
          = payload.action
          %span= avatar_image_tag payload.assignee.avatar_url
          %a{href: payload.assignee.html_url}= payload.assignee.login
          = payload.action == 'assigned' ? 'to' : 'from'
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
