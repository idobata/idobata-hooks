module Idobata::Hook
  class Kibela < Base
    screen_name 'kibe.la'
    icon_url hook_image_url('icon.png')
    template_name { "#{action}.html.haml" }
    before_render do
      skip_processing! if payload.action == "update" && !payload.notify
    end

    private

    def action
      payload.action
    end

    def hide_body?
      value_to_boolean(params[:hide_body])
    end
  end
end
