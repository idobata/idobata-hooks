require 'action_view/helpers/capture_helper'
require 'action_view/helpers/output_safety_helper'
require 'action_view/helpers/url_helper'

module Idobata::Hook
  class Kibela
    module Helper
      include ActionView::Helpers::UrlHelper

      def title
        return payload[resource_type].title unless resource_type == 'comment'
        payload.comment.blog&.title || payload.comment.wiki&.title
      end

      def url
        payload[resource_type].url
      end

      def resource_type
        payload.resource_type
      end
    end
  end
end
