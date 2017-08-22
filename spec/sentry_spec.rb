describe Idobata::Hook::Sentry, type: :hook do
  let(:payload) { fixture_payload("sentry/#{fixture}") }

  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    describe 'event level is fatal' do
      let(:fixture) { 'fatal.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-danger'>fatal</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is error' do
      let(:fixture) { 'error.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-danger'>error</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is warning' do
      let(:fixture) { 'warning.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-warning'>warning</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is info' do
      let(:fixture) { 'info.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-info'>info</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is debug' do
      let(:fixture) { 'debug.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-info'>debug</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'event level is unknown' do
      let(:fixture) { 'unknown.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          Project Project Name received an event
          <a href='https://app.getsentry.com/getsentry/project-slug/group/27379932/'>#27379932</a>
          :
          <span class='label label-default'>unknown</span>
        </p>
        <p>
          <b>This is an example exception</b>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
