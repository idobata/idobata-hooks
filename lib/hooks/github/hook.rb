module Idobata::Hook
  class Github < Base
    name          'GitHub'
    identifier    :github
    icon_url      gravatar('61024896f291303615bcd4f7a0dcfb74')
    form_json_key 'payload'
    template_name { "#{event_type}.html.haml" }

    helper Helper

    before_render do
      raise BadRequest, 'This is GitHub hook, who are you?' unless event_type

      skip_processing! if [
        unsupported_event_types.include?(event_type),
        event_type == 'pull_request' && payload.action == 'synchronize',
        event_type == 'push'         && payload.deleted,
        event_type == 'push'         && payload.commits.blank?,
      ].any?
    end

    private

    def event_type
      headers['X-GitHub-Event']
    end

    def unsupported_event_types
      %w(
        deployment
        fork
        member
        release
        page_build
        status
        deployment_status
        watch
        public
        team_add
      )
    end
  end
end
