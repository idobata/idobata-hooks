require 'uri'

module Idobata::Hook
  class PivotalTracker
    module Helper
      filters = [
        ::HTML::Pipeline::MarkdownFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true, base_url: 'https://www.pivotaltracker.com/')

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def new_value(kind)
        new_values(kind).first
      end

      def new_values(kind)
        payload.changes.select {|change| change.kind == kind.to_s }.map(&:new_values).compact
      end

      def download_url(attachment)
        download_url = URI.parse(attachment.download_url)

        # XXX Current API returns only path info.
        unless download_url.host
          download_url.scheme = 'https'
          download_url.host   = 'www.pivotaltracker.com'
        end

        download_url.query = {inline: true}.to_param unless download_url.query

        download_url.to_s
      end
    end
  end
end
