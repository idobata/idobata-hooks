require 'spec_helper'

describe Idobata::Hook::Crashlytics, type: :hook do
  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'verification' do
      let(:payload) { fixture_payload("crashlytics/verification.json") }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <h4>Crashlytics WebHook has been registered!</h4>
      HTML
    end

    context 'issue_impact_change' do
      let(:payload) { fixture_payload("crashlytics/issue_impact_change.json") }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span class='label label-info'>
            54 crashes, 16 devices
          </span>
          com.example.myapp 1.0.3 (4)
        </p>
        <h4>Issue Title</h4>
        <h5>com.example.myapp.MyAppUtil.methodName</h5>
        <p>http://crashlytics.com/full/url/to/issue</p>
      HTML
    end
  end
end
