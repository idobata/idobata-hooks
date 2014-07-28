require 'spec_helper'

describe Idobata::Hook::JenkinsNotification, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    shared_examples 'processing payload with URL to job' do
      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project support build
          <a href='http://localhost:8080/job/support/148/'>#148</a>
          :
          <span class='label label-success'>SUCCESS</span>
        </p>
      HTML
      its([:format]) { should eq(:html) }
    end

    context 'phase is "FINALIZED"' do
      it_should_behave_like 'processing payload with URL to job' do
        let(:payload) { fixture_payload('jenkins_notification/finalized.json') }
      end
    end

    context 'phase is "FINISHED"' do
      it_should_behave_like 'processing payload with URL to job' do
        let(:payload) { fixture_payload('jenkins_notification/finished.json') }
      end
    end

    context 'Old jenkins (build.full_url is missing)' do
      let(:payload) { fixture_payload('jenkins_notification/finished_old.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should == <<-HTML.strip_heredoc }
        <p>
          Project support build
          #148
          :
          <span class='label label-success'>SUCCESS</span>
        </p>
      HTML
    end

    context 'Old jenkins (Content-Type is missing)' do
      let(:payload) { fixture_payload('jenkins_notification/finished.json') }

      before do
        post payload
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project support build
          <a href='http://localhost:8080/job/support/148/'>#148</a>
          :
          <span class='label label-success'>SUCCESS</span>
        </p>
      HTML
      its([:format]) { should eq(:html) }
    end

    context 'phase is not "FINISHED"' do
      let(:payload) { fixture_payload('jenkins_notification/started.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      subject { ->{ hook.process_payload } }

      it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
    end
  end
end
