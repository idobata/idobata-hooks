module Idobata::Hook
  class TravisCI < Base
    screen_name   'Travis CI'
    icon_url      gravatar('253768044712357787be0f6a3a53cc66')
    form_json_key 'payload'
  end
end
