require 'idobata/hook'

require 'net/http'

require 'action_dispatch/http/headers'
require 'sinatra/base'
require 'sinatra/multi_route'
require 'sprockets'

raise 'Missing environment variable: `IDOBATA_HOOK_URL` is required.' unless ENV['IDOBATA_HOOK_URL']

module Idobata::Hook
  configure do |config|
    config.image_root = '/assets'
    config.image_host = ENV['IDOBATA_HOOK_HOST']
  end

  class Application < Sinatra::Application
    register Sinatra::MultiRoute

    set :idobata_hook_url, ENV['IDOBATA_HOOK_URL']

    set :sprockets, Sprockets::Environment.new

    configure do
      sprockets.append_path Idobata::Hook.root.join('hooks')
    end

    get '/' do
      'hi from Idobata::Hooks.'
    end

    route :get, :post, '/:identifier' do
      hook = Idobata::Hook.find(params[:identifier])

      raw_body = env['rack.input'].read

      headers = ActionDispatch::Http::Headers.new(env)

      payload = hook.new(raw_body, headers, params).process_payload

      post_to_idobata payload

      'OK'
    end

    route :head, '/:identifier' do
      Idobata::Hook.find(params[:identifier])
    end

    error Idobata::Hook::SkipProcessing do |e|
      status 200

      e.message
    end

    error Idobata::Hook::BadRequest do |e|
      status 422

      e.message
    end

    private

    def post_to_idobata(payload)
      url  = URI(settings.idobata_hook_url)
      post = Net::HTTP::Post.new(url)

      post.set_form generate_form(payload), 'multipart/form-data'

      Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == 'https') do |http|
        http.request post
      end
    end

    def generate_form(payload)
      images = Array(payload[:images]).map {|image|
        ['image[]', image.tempfile, filename: image.filename, content_type: image.type]
      }

      [
        ['source', payload[:source].to_s],
        ['format', payload[:format].to_s],
        *images
      ]
    end
  end
end
