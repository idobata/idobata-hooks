describe Idobata::Hook::Cloudformation, type: :hook do
  describe '#process_payload' do
    before do
      post payload, 'Content-Type' => 'application/json'
    end

    subject { hook.process_payload }

    describe 'subscription_confirmation' do
      let(:payload) { fixture_payload('cloudformation/subscription_confirmation.json') }

      its([:source]) { should eq <<-HTML.strip_heredoc }
        <p>
          You have chosen to subscribe to the topic
          <b>arn:aws:sns:us-east-1:xxxxx:topic</b>.
          To confirm the subscription, visit the
          <a href='https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&amp;TopicArn=arn:aws:sns:us-east-1:xxxxx:topic&amp;Token=xxxxx'>SubscribeURL</a>.
        </p>
      HTML
      its([:format]) { should eq :html }
    end

    describe 'notification' do
      context 'resource status reason is included' do
        let(:payload) { fixture_payload('cloudformation/notification_including_reason.json') }

        its([:source]) { should eq <<-HTML.strip_heredoc }
          <p>
            <span class='label label-warning'>CREATE_IN_PROGRESS</span>
            <b>stack:</b>
            VPC
            (AWS::EC2::VPC)
          </p>
          <p>
            Resource creation Initiated
          </p>
        HTML
        its([:format]) { should eq :html }
      end

      context %q{resource status reason isn't included} do
        let(:payload) { fixture_payload('cloudformation/notification.json') }

        its([:source]) { should eq <<-HTML.strip_heredoc }
          <p>
            <span class='label label-success'>CREATE_COMPLETE</span>
            <b>stack:</b>
            VPC
            (AWS::EC2::VPC)
          </p>
        HTML
        its([:format]) { should eq :html }
      end
    end
  end
end
