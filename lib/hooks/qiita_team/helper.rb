module Idobata::Hook
  class QiitaTeam < Base
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true)

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def user_url(base_url, url_name)
        URI.join(base_url, "/#{url_name}")
      end
    end
  end
end
