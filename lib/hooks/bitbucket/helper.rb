require 'pygments'

module Idobata::Hook
  class Bitbucket
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true, base_url: 'https://bitbucket.org/')

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def bitbucket_url(path = nil)
        url = 'https://bitbucket.org'
        url << '/' << path if path
        url
      end

      def pull_request_name_from_api_url(api_url)
        # pull request number is not contained in payload...
        repository_name, number = api_url.match(%r{/repositories/(.+/.+)/pullrequests/(\d+)/comments/})[1..2]

        "#{repository_name}##{number}"
      end
    end
  end
end
