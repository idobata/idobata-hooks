module Idobata::Hook
  class Github
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter,
        ::HTML::Pipeline::MentionFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true, base_url: 'https://github.com/')

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
          %span.label(style="background-color: ##{payload.label.color}")= payload.label.name
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
          'label-important'
        else
          nil
        end
      end
    end
  end
end
