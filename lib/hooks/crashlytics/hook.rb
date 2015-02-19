module Idobata::Hook
  class Crashlytics < Base
    screen_name         'Crashlytics'
    identifier          :crashlytics
    icon_url            'https://crashlytics.com/apple-touch-icon-crashlytics.png'
    forced_content_type :json
    template_name       { custom_template_name }

    helper Helper

    private

    def custom_template_name
      if payload['event'] == 'verification'
        'verification.html.haml'
      elsif payload['event'] == 'issue_impact_change'
        'default.html.haml'
      end
    end
  end
end
