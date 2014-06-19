require 'bundler/setup'

require_relative 'app'

map Idobata::Hook.image_root do
  run Idobata::Hook::Application.sprockets
end

run Idobata::Hook::Application
