module Idobata::Hook
  class Kibela < Base
    screen_name 'kibe.la'
    icon_url hook_image_url('icon.png')
    template_name { "#{template}.html.haml" }
    helper        Helper

    before_render do
      skip_processing! if skip?
    end

    private

    def skip?
      payload.action == "update" && (payload.resource_type == "comment" || !payload.notify)
    end

    def template
      payload.resource_type == "comment" ? "comment" : "page"
    end

    def hide_body?
      value_to_boolean(params[:hide_body])
    end
  end
end
