describe Idobata::Hook::Mackerel, type: :hook do
  let(:payload) { fixture_payload("mackerel/#{payload_type}.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on alert which has host information' do
      let(:payload_type) { 'alert' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          <span class='label label-danger'>CRITICAL</span>
          connectivity at app01 (working) Service: role
          (<a href='https://mackerel.io/orgs/.../alerts/2bj...'>detail</a>)
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context "on alert which doesn't have any host information" do
      let(:payload_type) { 'alert_external_monitor' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          <span class='label label-danger'>CRITICAL</span>
          An external http monitor
          (<a href='https://mackerel.io/orgs/hibariya/alerts/2NqjowLMnZn'>detail</a>)
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on sample' do
      let(:payload_type) { 'sample' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          sample: Sample Notification from Mackerel
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
