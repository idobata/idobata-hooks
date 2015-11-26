module Idobata::Hook
  class Backlog < Base
    screen_name 'backlog'
    icon_url hook_image_url('icon.png')
    template_name { "issue.html.haml" }

    helper Helper

    EVENTS = {
      1  => 'created',
      2  => 'updated',
      3  => 'commented',
      4  => 'issue deleted',
      14 => 'multiple issues updated',
      17 => 'noticed',
    }

    before_render do
      skip_processing! unless EVENTS.keys.include?(payload.type)
    end

    private

    def space_id
      params[:space_id] || nil
    end

    def type_label
      EVENTS[payload.type]
    end
  end
end
