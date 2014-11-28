module Idobata::Hook
  class Gitlab
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true)

      NULL_COMMIT = '0'*40

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def tag_type(payload)
        return :created if payload.before == NULL_COMMIT
        return :deleted if payload.after  == NULL_COMMIT

        raise "Unknown tag type: before=#{payload.before}, after=#{payload.after}"
      end

      def repository_name(repository)
        repository.homepage.split('/', 4).last # https://example.com/:owner/:name
      end
    end
  end
end
