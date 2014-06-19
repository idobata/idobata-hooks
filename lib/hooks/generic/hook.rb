module Idobata::Hook
  class Generic < Base
    name        'Generic'
    identifier  :generic
    icon_url    gravatar('9fef32520aa08836d774873cb8b7df28')

    before_render do
      add_description 'WARNING: "body" is deprecated. Use "source" instead.' if payload.body
    end

    def source
      # To compatible old param name `body`.
      # TODO Remove this some day...
      payload.source || payload.body
    end

    def format
      payload.format || :plain
    end

    def images
      [payload.image].flatten.compact
    end
  end
end
