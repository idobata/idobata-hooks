require 'action_view/helpers/capture_helper'
require 'action_view/helpers/output_safety_helper'
require 'action_view/helpers/url_helper'

module Idobata::Hook
  class Backlog < Base
    module Helper
      include ActionView::Helpers::UrlHelper

      def backlog_url_base
        return nil unless space_id

        "https://#{space_id}.backlog.jp/view/"
      end

      def issue_link(summary, key_id, comment = nil)
        return summary unless space_id

        url  = "#{backlog_url_base}#{payload.project.projectKey}-#{key_id}"
        url += "#comment-#{comment.id}" if comment

        link_to(summary, url)
      end

      def hbr(source)
        html_escape(source).gsub(/\r\n|\r|\n/, '<br />').html_safe
      end
    end
  end
end
