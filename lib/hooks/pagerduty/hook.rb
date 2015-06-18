module Idobata::Hook
  class Pagerduty < Base
    screen_name 'PagerDuty'
    icon_url    hook_image_url('icon.png')

    helper Helper
  end
end
