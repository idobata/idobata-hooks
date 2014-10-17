module Idobata::Hook
  class Bugsnag < Base
    screen_name   'Bugsnag'
    identifier    :bugsnag
    icon_url      gravatar('7e8b5cfa0dbe9df4205ab6d811fddd31')
    template_name { custom_template_name }

    private

    def custom_template_name
      case payload.trigger.type
      when 'comment'
        'comment.html.haml'
      else
        'default.html.haml'
      end
    end
  end
end
