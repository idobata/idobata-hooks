module Idobata::Hook
  class Trello < Base
    class TemplateNameMapper
      class Default
        def call(payload)
          [payload.action.type.underscore, 'html', 'haml'].join('.')
        end
      end

      class Unknown
        def call(payload)
          nil
        end
      end

      class UpdateCard
        def call(payload)
          sub_action = if payload.action.data.listAfter?
                         'move'
                       elsif payload.action.data.card.key?('closed')
                         payload.action.data.card.closed ? 'archive' : 'unarchive'
                       elsif payload.action.data.old.name?
                         'update_name'
                       elsif payload.action.data.old.desc?
                         'update_description'
                       elsif payload.action.data.card.key?('due')
                         payload.action.data.card.due ? 'update_due' : 'remove_due'
                       end
          return nil unless sub_action
          ["#{payload.action.type.underscore}_#{sub_action}", 'html', 'haml'].join('.')
        end
      end

      class UpdateList
        def call(payload)
          sub_action = if payload.action.data.list.key?('closed')
                         payload.action.data.list.closed ? 'archive' : 'unarchive'
                       elsif payload.action.data.old.name?
                         'update_name'
                       end
          return nil unless sub_action
          ["#{payload.action.type.underscore}_#{sub_action}", 'html', 'haml'].join('.')
        end
      end

      class UpdateBoard
        def call(payload)
          sub_action = payload.action.data.board.labelNames? ? 'add_label' : nil
          return nil unless sub_action
          ["#{payload.action.type.underscore}_#{sub_action}", 'html', 'haml'].join('.')
        end
      end

      class << self
        def call(payload)
          begin
            const_get(payload.action.type.camelcase, false)
          rescue NameError
            Unknown
          end.new.call(payload)
        end

        def supports(action)
          class_name = action.to_s.camelcase
          const_set(class_name, Class.new(Default)) unless const_defined?(class_name, false)
        end
      end

      supports :create_card
      supports :update_card
      supports :delete_card
      supports :comment_card
      supports :add_member_to_card
      supports :remove_member_from_card
      supports :add_label_to_card
      supports :remove_label_from_card
      supports :create_list
      supports :update_list
      supports :move_list_from_board
      supports :update_board
    end
  end
end
