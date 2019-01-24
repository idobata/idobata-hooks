module Idobata::Hook
  class Vein < Base
    screen_name 'Vein'
    icon_url hook_image_url('icon.png')

    def usericon
      payload.icon_url
    rescue
      '__WARNING: It could not make "usericon", please check your idobata hook settings.__'
    end

    def username
      payload.username.gsub(/ \(VeinBot\)$/, '')
    rescue
      '__WARNING: It could not make "username", please check your idobata hook settings.__'
    end

    def body
      payload.text.gsub(/\nshared by Vein$/, '')
    rescue
      '__WARNING: It could not make "body", please check your idobata hook settings.__'
    end
  end
end
