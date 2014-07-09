module Idobata::Hook
  class Bitbucket < Base
    screen_name   'Bitbucket'
    identifier    :bitbucket
    icon_url      hook_image_url('icon.png')
    form_json_key 'payload'
    template_name { "#{event_type}.html.haml" }

    helper Helper

    before_render do
      skip_processing! if %w(
          pullrequest_comment_deleted
          pullrequest_approve
          pullrequest_unapprove
        ).include?(event_type)
    end

    private

    def event_type
      @event_type ||= detect_template
    end

    def detect_template
      return :push if payload.commits

      # type is contained in JSON as root key.
      payload.keys.first
    end
  end
end
