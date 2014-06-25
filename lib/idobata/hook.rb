require 'hashie'
require 'html/pipeline'
require 'json'
require 'mime/types'
require 'tilt'
require 'active_support/callbacks'
require 'active_support/core_ext/class/subclasses'
require 'active_support/core_ext/object/to_param'
require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/string/inflections'

begin
  require 'linguist'
rescue LoadError
  # linguist doesn't work on Heroku, so ignore it
end

require 'idobata/hook/html_safe_haml' unless defined?(Rails)
require 'idobata/hook/version'
require 'idobata/hook/helper'
require 'idobata/hook/base'
require 'idobata/hook/errors'

module Idobata
  module Hook
    class << self
      attr_accessor :image_root, :image_host

      def root
        Pathname(File.expand_path('../', __dir__))
      end

      def all
        load!

        Base.subclasses
      end

      def find(identifier)
        all.find {|hook| hook.identifier.to_s == identifier.to_s } || raise(Error, "identifier not found: `#{identifier}`")
      end

      def load!
        Dir[root.join('hooks/*/hook.rb')].each do |f|
          require f
        end
      end

      def configure
        yield self
      end
    end

    configure do |config|
      config.image_root = '/assets'
      config.image_host = nil
    end
  end
end
