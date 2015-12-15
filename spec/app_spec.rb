require 'app_helper'

describe Idobata::Hook::Application, type: :app do
  let(:app) { Idobata::Hook::Application.new }

  it 'get /' do
    get '/'
    expect(last_response.body).to eq 'hi from Idobata::Hooks.'
  end

  it 'head /custom' do
    head '/custom'
    expect(last_response).to be_ok
  end

  it 'post /custom' do
    VCR.use_cassette 'custom' do
      post '/custom', 'source=hello%20world'
      expect(last_response).to be_ok
    end
  end
end
