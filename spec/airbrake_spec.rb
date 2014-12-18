require 'spec_helper'

describe Idobata::Hook::Airbrake, type: :hook do
  let(:payload) { fixture_payload("airbrake/#{fixture}.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'via rack' do
      let(:fixture) { 'rack_error' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span class='label label-info'>Airbrake</span>
          <span class='label label-info'>production</span>
          <span class='badge badge-important'>118</span>
        </p>
        <p>
          <b>RuntimeError: You threw an exception for testing</b>
          from
          <a href='http://airbrake.io:445/pages/exception_test'>http://airbrake.io:445/pages/exception_test</a>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'standalone' do
      let(:fixture) { 'standalone_error' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span class='label label-info'>idobata-hooks</span>
          <span class='label label-info'></span>
          <span class='badge badge-important'>1</span>
        </p>
        <p>
          <b>NameError: undefined local variable or method `hi' for main:Object</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
