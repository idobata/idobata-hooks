require 'spec_helper'

describe Idobata::Hook::Sentry, type: :hook do
  let(:payload) { fixture_payload("sentry/#{fixture}") }

  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    describe 'event level is fatal' do
      let(:fixture) { 'fatal.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-danger'>fatal</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is error' do
      let(:fixture) { 'error.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-danger'>error</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is warning' do
      let(:fixture) { 'warning.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-warning'>warning</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is info' do
      let(:fixture) { 'info.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-info'>info</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is debug' do
      let(:fixture) { 'debug.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-info'>debug</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is unknown' do
      let(:fixture) { 'unknown.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-default'>unknown</span>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
