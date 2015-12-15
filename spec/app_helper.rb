require 'rack/test'
require 'webmock'
require 'vcr'
require 'spec_helper'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.ignore_localhost = true
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :app
end

ENV['IDOBATA_HOOK_URL'] = 'https://idobata.io/hook/custom/7e90939f-d82b-40fa-9677-427a5366de4d'
require './app'
