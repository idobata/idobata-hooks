module Idobata::Hook
  module Helper
    def avatar_image_tag(src, size: 16)
      Haml::Util.html_safe(%(<img src="#{Haml::Helpers.escape_once(src)}" width="#{size}" height="#{size}" alt="" />))
    end

    def gravatar_image_tag(email, size: 16)
      id = Digest::MD5.hexdigest(email.to_s)

      avatar_image_tag("https://secure.gravatar.com/avatar/#{id}?s=#{size * 2}&d=mm", size: size)
    end

    # This code based on: https://github.com/rails/rails/blob/v4.1.1/activesupport/lib/active_support/number_helper/number_to_delimited_converter.rb

    DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

    def number_with_delimiter(number, delimiter: ',')
      number = number.to_s
      return number if number.empty?

      left, right = number.split('.')
      left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
        "#{digit_to_delimit}#{delimiter}"
      end
      parts = [left, right].compact

      parts.join(delimiter)
    end
  end
end
