describe Idobata::Hook::Bugsnag, type: :hook do
  let(:payload) { fixture_payload("bugsnag/#{payload_type}.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on comment' do
      let(:payload_type) { 'comment' }
      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          foobarbaz commented on
          <a href='https://bugsnag.com/example/rails/errors/2345bcds?event_id=12345abc'><b>RuntimeError</b> rake#test_exception</a>
        </p>
        <ul>
        <li>コメントですよ</li>
        </ul>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on error' do
      let(:payload_type) { 'error' }
      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <p>
          <span class='label label-danger'>Error</span>
          <a href='https://bugsnag.com/example/rails/errors/2345bcds?event_id=12345abc'>
            <b>RuntimeError</b> rake#test_exception
          </a>
        </p>
        <p>
          <i>Bugsnag test exception</i>
        </p>
        <p>
          has occurred 8 time(s) on development
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
