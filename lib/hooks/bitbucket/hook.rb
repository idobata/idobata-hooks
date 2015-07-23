module Idobata::Hook
  class Bitbucket < Base
    EVENTS = %w(repo:push pullrequest:created pullrequest:fulfilled pullrequest:rejected pullrequest:comment_created)
    SERVICES_EVENT_BLACKLIST = %w(pullrequest_comment_deleted pullrequest_approve pullrequest_unapprove)

    screen_name   'Bitbucket'
    icon_url      hook_image_url('icon.png')
    form_json_key 'payload'
    template_name {
      if service?
        "services/#{event_type}.html.haml"
      else
        "#{event_type.sub(/:/, '_')}.html.haml"
      end
    }

    helper Helper

    before_render do
      if service?
        skip_processing! if SERVICES_EVENT_BLACKLIST.include?(event_type)
      else
        skip_processing! unless EVENTS.include?(event_key)
      end
    end

    private

    def event_type
      if service?
        # type is contained in JSON as root key.
        payload.commits ? :push : payload.keys.first
      else
        event_key
      end
    end

    def service?
      event_key.blank?
    end

    def event_key
      headers['X-Event-Key']
    end
  end
end
