module Idobata::Hook
  class Papertrail < Base
    screen_name   'Papertrail'
    identifier    :papertrail
    icon_url      gravatar('e52fd880666c3708c72496114a64dec0')
    form_json_key 'payload'
  end
end
