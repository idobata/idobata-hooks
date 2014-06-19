# This code is subset of: https://github.com/haml/haml/blob/4.0.5/lib/haml/template.rb

require 'haml'
require 'haml/helpers/xss_mods'

require 'active_support/core_ext/string/output_safety'

module Haml
  class Compiler
    def precompiled_method_return_value_with_haml_xss
      "::Haml::Util.html_safe(#{precompiled_method_return_value_without_haml_xss})"
    end
    alias_method :precompiled_method_return_value_without_haml_xss, :precompiled_method_return_value
    alias_method :precompiled_method_return_value, :precompiled_method_return_value_with_haml_xss
  end

  module Helpers
    include Haml::Helpers::XssMods
  end
end
