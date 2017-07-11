describe Idobata::Hook::Pagerduty, type: :hook do
  describe '#process_payload' do
    let(:payload) { fixture_payload('pagerduty/default.json') }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    subject { hook.process_payload }

    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <span class='label label-danger'>triggered</span>
        <b>Service:</b>
        Description
        (<a href='https://subdomain.pagerduty.com/incidents/xxxxx'>detail</a>)
      </p>
    HTML
    its([:format]) { should eq :html }
  end
end
