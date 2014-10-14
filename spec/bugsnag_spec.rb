require 'spec_helper'

describe Idobata::Hook::Bugsnag, type: :hook do
  let(:payload) { fixture_payload("bugsnag/#{payload_type}.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on comment' do
      let(:payload_type) { 'comment' }
      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          foobarbaz commented on
          <a href='https://bugsnag.com/example/rails/errors/2345bcds?event_id=12345abc'>[RuntimeError]</a>
        </p>
        <p>
          <ul>
          <li>コメントですよ</li>
          </ul>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on error' do
      let(:payload_type) { 'error' }
      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span class='label label-important'>Exception</span>
          <a href='https://bugsnag.com/example/rails/errors/2345bcds?event_id=12345abc'>[RuntimeError]</a>
        </p>
        <p>
          Bugsnag test exception
        </p>
        <p>
          has occurred 8 time(s) on development
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
