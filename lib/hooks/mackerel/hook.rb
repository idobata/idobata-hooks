module Idobata::Hook
  class Mackerel < Base
    screen_name   'Mackerel'
    icon_url      'https://github.com/mackerelio.png'
    template_name { custom_template_name }
    helper        Helper

    private

    def custom_template_name
      if payload.event == 'alert'
        'alert.html.haml'
      else
        'default.html.haml'
      end
    end

  end
end
