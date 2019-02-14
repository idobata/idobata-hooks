module Idobata::Hook
  class Vein < Base
    screen_name 'Vein'
    icon_url hook_image_url('icon.png')

    def usericon
      payload.icon_url
    end

    def username
      payload.username.gsub(/ \(VeinBot\)$/, '')
    end

    def body
      payload.text.gsub(/\nshared by Vein$/, '')
    end
  end
end
