module Idobata::Hook
  class Sentry < Base
    screen_name 'Sentry'
    identifier  :sentry
    icon_url    hook_image_url('icon.png')

    helper Helper
  end
end
