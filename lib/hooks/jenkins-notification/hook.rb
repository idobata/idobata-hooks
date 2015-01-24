module Idobata::Hook
  class JenkinsNotification < Base
    screen_name         'Jenkins'
    icon_url            gravatar('ceb204ad3216b4594ba32364def06deb')
    forced_content_type :json

    helper Helper

    before_render do
      skip_processing! unless %w( FINISHED FINALIZED ).include?(payload.build.phase)
    end
  end
end
