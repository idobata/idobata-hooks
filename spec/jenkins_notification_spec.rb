require 'spec_helper'

describe Idobata::Hook::JenkinsNotification, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    context 'phase is "FINISHED"' do
      let(:payload) { fixture_payload('jenkins_notification/finished.json') }

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

      it { expect(subject).to throw_symbol(:skip_processing) }
    end
  end
end
