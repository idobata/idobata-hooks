module Idobata::Hook
  class Newrelic < Base
    name          'New Relic'
    identifier    :newrelic
    icon_url      gravatar('a92deb072c8974ac94f6446da067c3b7')
    template_name { "#{payload.keys.first}.html.haml" }

    private

    def _payload
      payload = super

      type = payload.keys.first # Using `form_json_key` losts key...

      { type => JSON.parse(payload[type]) }
    end
  end
end
