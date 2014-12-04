require 'spec_helper'

describe Idobata::Hook::Airbrake, type: :hook do
  let(:payload) { fixture_payload('airbrake/error.json') }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

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
end
