module Idobata::Hook
  class Docbase < Base
    screen_name 'DocBase'
    icon_url hook_image_url('icon.png')
    template_name { "#{payload.action}.html.haml" }

    helper Helper
  end
end
