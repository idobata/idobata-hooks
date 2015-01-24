require_relative 'template_name_mapper'

module Idobata::Hook
  class Trello < Base
    screen_name   'Trello'
    icon_url      'https://s3.amazonaws.com/trello/images/og/trello-icon.png'
    template_name { custom_template_name }

    helper Helper

    before_render do
      skip_processing! unless template_name_mapper.call(payload)
    end

    private

    def custom_template_name
      template_name_mapper.call(payload)
    end

    def template_name_mapper
      @template_name_mapper ||= TemplateNameMapper
    end
  end
end
