module Idobata::Hook
  class Cloudformation < Base
    screen_name         'CloudFormation'
    icon_url            hook_image_url('icon.png')
    forced_content_type :json
    template_name       { "#{type}.html.haml" }

    helper Helper

    private

    def type
      case payload['Type']
      when 'SubscriptionConfirmation'
        'subscription_confirmation'
      when 'Notification'
        'notification'
      end
    end
  end
end
