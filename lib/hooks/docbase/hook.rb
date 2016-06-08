module Idobata::Hook
  class Docbase < Base
    screen_name 'DocBase'
    icon_url hook_image_url('icon.png')
    template_name { "#{event_type}.html.haml" }

    helper Helper

    private

    def event_type
      case payload.action
      when 'post_publish'      then 'post_publish'
      when 'post_update'       then 'post_update'
      when 'post_group_update' then 'post_group_update'
      when 'sharing_create'    then 'sharing_create'
      when 'sharing_destroy'   then 'sharing_destroy'
      when 'comment_create'    then 'comment_create'
      when 'star_create'       then 'star_create'
      when 'like_create'       then 'like_create'
      when 'team_join'         then 'team_join'
      when 'group_join'        then 'group_join'
      else
        'default'
      end
    end
  end
end
