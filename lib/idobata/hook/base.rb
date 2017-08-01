require 'action_dispatch/http/mime_type'
require 'active_support/rescuable'

module Idobata::Hook
  class Payload < Hashie::Mash
    # XXX: payload contains :size ...
    disable_warnings
  end

  class Base
    include ActiveSupport::Callbacks
    include ActiveSupport::Rescuable

    define_callbacks :render

    attr_reader :raw_body, :headers, :params

    class << self
      def define_config_accessor(*names)
        names.each do |name|
          singleton_class.send :define_method, name do |value = nil|
            if value.nil?
              instance_variable_get "@#{name}"
            else
              instance_variable_set "@#{name}", value
            end
          end
        end
      end

      def identifier
        name.underscore.split('/').last
      end

      def gravatar(id)
        "https://secure.gravatar.com/avatar/#{id}?d=mm"
      end

      def hook_image_url(filename)
        prefix = File.join(*[Idobata::Hook.image_host, Idobata::Hook.image_root].compact)

        File.join(prefix, identifier, 'images', filename)
      end

      def hook_root
        Idobata::Hook.root.join('hooks', identifier.dasherize)
      end

      def template_name(&block)
        if block_given?
          @template_name = block
        else
          @template_name || proc { 'default.html.haml' }
        end
      end

      def proper_hook?
        name.present?
      end

      private

      def inherited(klass)
        klass.autoload :Helper, "hooks/#{klass.identifier.dasherize}/helper" if klass.proper_hook?

        super
      end

      def before_render(&block)
        set_callback :render, :before, &block
      end

      def helper(helper)
        before_render do |hook|
          hook.extend helper
        end
      end
    end

    define_config_accessor :screen_name, :icon_url, :forced_content_type, :form_json_key

    helper Helper

    def initialize(raw_body, headers, params)
      @raw_body = raw_body
      @headers  = headers
      @params   = params
    end

    def process_payload
      run_callbacks :render do
        {
          source: source && source.force_encoding(Encoding::UTF_8),
          format: format,
          images: images
        }
      end
    end

    def source
      render(instance_eval(&self.class.template_name))
    end

    def format
      :html
    end

    def images
      nil
    end

    def description
      @description ||= ''
    end

    private

    def render(template_name, locals = {})
      template_path = self.class.hook_root.join('templates', template_name)

      Tilt.new(template_path.to_s, escape_html: true).render(self, locals)
    end

    def payload
      @payload ||= Payload.new(_payload)
    end

    def _payload
      raw_content_type = headers['Content-Type']

      case normalized_content_type
      when Mime[:json]
        JSON.parse(raw_body)
      when Mime[:xml]
        Hash.from_xml(raw_body)
      when Mime[:url_encoded_form]
        payload = Rack::Utils.parse_nested_query(raw_body)

        parse_json_in_form(payload)
      when Mime[:multipart_form]
        payload = Rack::Multipart.parse_multipart(
          'CONTENT_TYPE'   => raw_content_type,
          'CONTENT_LENGTH' => raw_body.length,
          'rack.input'     => StringIO.new(raw_body)
        )

        parse_json_in_form(payload)
      else
        raise UnsupportedContentType, "Unsupported content_type: `#{raw_content_type}`."
      end
    rescue => e
      rescue_with_handler(e) || raise
    end

    def normalized_content_type
      return Mime[self.class.forced_content_type] if self.class.forced_content_type

      case type = headers['Content-Type']
      when /\A#{Regexp.quote(Mime[:multipart_form])}\b/
        Mime[:multipart_form]
      when nil
        Mime[:url_encoded_form]
      else
        Mime::Type.parse(type)
      end
    end

    def skip_processing!
      raise SkipProcessing
    end

    def add_description(description)
      self.description << description
    end

    def hook_image_url(filename)
      self.class.hook_image_url(filename)
    end

    def parse_json_in_form(payload)
      return payload unless key = self.class.form_json_key

      JSON.parse(payload[key])
    end
  end
end
