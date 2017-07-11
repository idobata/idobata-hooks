describe Idobata::Hook::Crashlytics, type: :hook do
  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'verification' do
      let(:payload) { fixture_payload('crashlytics/verification.json') }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <h4>Crashlytics WebHook has been registered!</h4>
      HTML
    end

    context 'issue_impact_change' do
      let(:payload) { fixture_payload('crashlytics/issue_impact_change.json') }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          <span class='label label-success'>
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
