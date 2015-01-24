module Idobata::Hook
  class PivotalTracker < Base
    screen_name   'Pivotal Tracker'
    icon_url      gravatar('cb76d5e8ca3eebb5b627f6194b14370c')
    template_name { "#{detect_api_version}.html.haml" }

    helper Helper

    private

    def detect_api_version
      if payload.activity
        :v3
      elsif payload.message
        :v5
      else
        raise Error, 'Unsupported version'
      end
    end
  end
end
