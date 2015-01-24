module Idobata::Hook
  class QiitaTeam < Base
    module Helper
      class QiitaHTMLFilter < HTML::Pipeline::Filter
        def call
          doc.tap {
            doc.search('span.fragment, span.fragment + a').each(&:remove)

            doc.search('img.emoji').each do |emoji|
              emoji.replace emoji_image_filter(emoji[:title])
            end
          }
        end

        # I'll forget I saw it :bow:
        def emoji_image_filter(text)
          HTML::Pipeline::EmojiFilter.new(nil, asset_root: '/images').emoji_image_filter(text)
        end
      end

      filters = [
        ::HTML::Pipeline::MarkdownFilter
      ]

      filters << ::HTML::Pipeline::SyntaxHighlightFilter if defined?(Linguist) # This filter doesn't work on heroku

      Pipeline = ::HTML::Pipeline.new(filters, gfm: true)

      def md(source)
        result = Pipeline.call(source)

        result[:output].to_s.html_safe
      end

      def fixup_qiita_html(html)
        QiitaHTMLFilter.new(html).call.to_s.html_safe
      end
    end
  end
end
