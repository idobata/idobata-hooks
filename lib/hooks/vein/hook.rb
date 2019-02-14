module Idobata::Hook
  class Vein < Base
    screen_name 'Vein'
    icon_url hook_image_url('icon.png')

    def usericon
      payload.icon_url
      # This value is used for a url of an image.
      # If it returns a warning message, it shows just broken image to users.
      # So, you should not make a warning message here.
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
