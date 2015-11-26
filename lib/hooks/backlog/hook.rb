module Idobata::Hook
  class Backlog < Base
    screen_name 'Backlog'
    icon_url hook_image_url('icon.png')
    template_name { "#{event_type}.html.haml" }

    helper Helper

    EVENTS = {
      1  => 'issue_created',
      2  => 'issue_updated',
      3  => 'issue_commented',
      4  => 'issue_deleted',
      14 => 'issue_multiple_updated',
      17 => 'issue_noticed',
    }

    before_render do
      skip_processing! unless event_type
    end

    private

    def event_type
      EVENTS[payload.type]
    end

    def space_id
      params[:space_id] || nil
    end

    def type_label
      EVENTS[payload.type]
    end
  end
end
