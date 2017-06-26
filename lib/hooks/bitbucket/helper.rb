require 'html/pipeline/rouge_filter'

module Idobata::Hook
  class Bitbucket
    module Helper
      module Services
        BITBUCKET_URL = 'https://bitbucket.org/'

        include Helper

        def md(source)
          markdown_pipeline(source, base_url: BITBUCKET_URL)
        end

        def bitbucket_url(path = nil)
          _path = path&.start_with?('/') ? path[1..-1] : path

          "#{BITBUCKET_URL}#{_path}"
        end

        def pull_request_name_from_api_url(api_url)
          # pull request number is not contained in payload...
          repository_name, number = api_url.match(%r{/repositories/(.+/.+)/pullrequests/(\d+)/comments/})[1..2]

          "#{repository_name}##{number}"
        end
      end
    end
  end
end
