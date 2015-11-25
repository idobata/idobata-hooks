module Idobata::Hook
  class Gitlab < Base
    screen_name   'Gitlab'
    icon_url      'https://github.com/gitlabhq.png'
    template_name { "#{event_type}.html.haml" }

    helper Helper

    EVENTS = %w(
      issue
      merge_request
      project_create
      push
      tag
    )

    before_render do
      skip_processing! unless EVENTS.include?(event_type)
    end

    private

    def event_type
      return 'push'              if payload.has_key?('commits')
      return 'tag'               if payload.has_key?('ref')
      return payload.object_kind if payload.has_key?('object_kind')
      return payload.event_name  if payload.has_key?('event_name')

      raise "Unknown Gitlab event: #{payload.to_json}"
    end
  end
end
