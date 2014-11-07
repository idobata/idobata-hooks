module Idobata::Hook
  class QiitaTeam < Base
    UNSUPPORTED_EVENTS = Set.new(%w(project))

    screen_name   'Qiita:Team'
    identifier    :qiita_team
    icon_url      gravatar('a42654d10bb5293ca1bfe6ab3ea049e5')
    template_name { "#{event_model_type}.html.haml" }

    helper Helper

    before_render do
      skip_processing! if destroyed? || UNSUPPORTED_EVENTS.include?(event_model_type)
    end

    private

    def event_model_type
      headers['X-Qiita-Event-Model'].downcase
    end

    def destroyed?
      payload.action == 'destroyed'
    end
  end
end
