describe Idobata::Hook::Newrelic, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post params.to_param, 'Content-Type' => 'application/x-www-form-urlencoded'
    end

    describe 'deployment hook' do
      let(:payload) { fixture_payload('newrelic/deployment.json') }
      let(:params)  { {deployment: payload} }

      its([:source]) { should == <<-HTML.strip_heredoc }
        <div>
          <b>Application name was deployed by Name of person deploying</b>
        </div>
        <div>
          Information about deployment
          (<a href='https://rpm.newrelic.com/accounts/[account_id]/applications/[application_id]/deployments/[deployment_id]'>detail</a>)
        </div>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'alert hook' do
      let(:payload) { fixture_payload('newrelic/server_alert.json') }
      let(:params)  { {alert: payload} }

      its([:source]) { should == <<-HTML.strip_heredoc }
        <div>
          <b>Alert opened on Server_name</b>
          <span class='label label-danger'>Critical</span>
        </div>
        <div>
          Memory &gt; 13%
          (<a href='https://rpm.newrelic.com/accounts/?????/incidents/????????'>detail</a>)
        </div>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
