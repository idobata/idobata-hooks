module Idobata::Hook
  class Bitbucket < Base
    # NOTE support for old webhooks (services)
    services_helper = Helper::Services
    @@services_hook = Class.new(Base) {|klass|
      def klass.hook_root
        Bitbucket.hook_root
      end

      helper        services_helper
      template_name { "services/#{event_type}.html.haml" }
      form_json_key 'payload'

      before_render do
        skip_processing! if %w(pullrequest_comment_deleted pullrequest_approve pullrequest_unapprove).include?(event_type)
      end

      private

      def event_type
        payload.commits ? :push : payload.keys.first
      end
    }

    EVENTS = %w(repo:push pullrequest:created pullrequest:fulfilled pullrequest:rejected pullrequest:comment_created)

    screen_name   'Bitbucket'
    icon_url      hook_image_url('icon.png')
    template_name { "#{event_key.sub(/:/, '_')}.html.haml" }

    helper Helper

    before_render do
      skip_processing! unless EVENTS.include?(event_key)
    end

    def process_payload
      return @@services_hook.new(raw_body, headers).process_payload if service?

      super
    end

    private

    def service?
      event_key.blank?
    end

    def event_key
      headers['X-Event-Key']
    end
  end
end
