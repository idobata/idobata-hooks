module Idobata::Hook
  class CircleCI < Base
    screen_name   'Circle CI'
    identifier    :circle_ci
    icon_url      gravatar('c37e5f37d63fe731f139b7da3f759139')

    def payload
      super.payload
    end
  end
end
