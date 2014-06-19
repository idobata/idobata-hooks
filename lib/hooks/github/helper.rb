module Idobata::Hook
  class Github
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter,
        ::HTML::Pipeline::MentionFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true, base_url: 'https://github.com/')

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end
    end
  end
end
