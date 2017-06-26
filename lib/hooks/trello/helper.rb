module Idobata::Hook
  class Trello < Base
    module Helper
      def link_to_member(member)
        capture_haml do
          member.avatarHash.present? ? _avatar(member) : _initials(member)
          haml_tag :a, member.username, { href: 'https://trello.com/'.freeze + member.username }
        end
      end

      def _avatar(member, size: 16)
        haml_tag :img, {
          src: sprintf('https://trello-avatars.s3.amazonaws.com/%s/30.png', member.avatarHash),
          width: size,
          height: size,
          alt: ''
        }
      end

      def _initials(member)
        haml_tag :span, member.initials, { class: 'trello-member-initials' }
      end

      def link_to_card(card)
        capture_haml do
          haml_tag :a, card.name, {
            href: 'https://trello.com/c/'.freeze + card.shortLink
          }
        end
      end

      def link_to_board(board)
        capture_haml do
          haml_tag :a, board.name, {
            href: 'https://trello.com/b/' + board.shortLink
          }
        end
      end

      def link_to_board_or_name(board)
        board.shortLink? ?  link_to_board(board) : capture_haml { board.name }
      end

      # temporary hack to use Haml::Helper methods
      # See https://github.com/idobata/idobata-hooks/issues/10
      def with_raw_haml_concat
        yield
      end
    end
  end
end
