require 'uri'

module Idobata::Hook
  class PivotalTracker
    module Helper
      PIVOTAL_TRACKER_URL = 'https://www.pivotaltracker.com/'

      def md(source)
        markdown_pipeline(source, base_url: PIVOTAL_TRACKER_URL)
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
