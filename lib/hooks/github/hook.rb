require 'set'

module Idobata::Hook
  class Github < Base
    EVENTS_TO_IGNORE = Set.new(
      %w(
        deployment
        fork
        member
        release
        page_build
        deployment_status
        public
        team_add
      )
    )

    screen_name   'GitHub'
    identifier    :github
    icon_url      gravatar('61024896f291303615bcd4f7a0dcfb74')
    form_json_key 'payload'
    template_name { "#{event_type}.html.haml" }

    helper Helper

    before_render do
      raise BadRequest, 'This is GitHub hook, who are you?' unless event_type

      skip_processing! if EVENTS_TO_IGNORE.include?(event_type) || synchronize_event? || create_branch_push_event? || delete_branch_push_event? || delete_label_event? || pending_status_event?
    end

    private

    def synchronize_event?
      event_type == 'pull_request' && payload.action == 'synchronize'
    end

    def create_branch_push_event?
      event_type == 'push' && payload.commits.blank?
    end

    def delete_branch_push_event?
      event_type == 'push' && payload.deleted
    end

    def delete_label_event?
      event_type == 'issues' && payload.action == 'unlabeled' && payload.label.blank?
    end

    def pending_status_event?
      event_type == 'status' && payload.state == 'pending'
    end

    def event_type
      headers['X-GitHub-Event']
    end
  end
end
