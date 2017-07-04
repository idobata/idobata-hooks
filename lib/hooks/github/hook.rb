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

    ACTIONS_TO_IGNORE = Set.new(
      [
        %w(pull_request synchronize),
        %w(issue_comment edited),
        %w(issue_comment deleted),
        %w(pull_request_review_comment edited),
        %w(pull_request_review_comment deleted),
        %w(issues edited),
        %w(pull_request edited)
      ]
    )

    screen_name   'GitHub'
    icon_url      gravatar('61024896f291303615bcd4f7a0dcfb74')
    form_json_key 'payload'
    template_name { "#{event_type}.html.haml" }

    helper Helper

    before_render do
      raise BadRequest, 'This is GitHub hook, who are you?' unless event_type

      skip_processing! if nop?
    end

    private

    def nop?
      EVENTS_TO_IGNORE.include?(event_type)                      ||
        ACTIONS_TO_IGNORE.include?([event_type, payload.action]) ||
        create_branch_push_event?                                ||
        delete_branch_push_event?                                ||
        delete_label_event?                                      ||
        pending_status_event?                                    ||
        review_comment_has_blank_body?
    end

    def review_comment_has_blank_body?
      event_type == 'pull_request_review' && payload.review.state == 'commented' && payload.review.body.blank?
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
