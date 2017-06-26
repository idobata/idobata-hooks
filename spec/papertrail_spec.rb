describe Idobata::Hook::Papertrail, type: :hook do
  let(:payload) { fixture_payload('papertrail.json') }
  let(:params)  { {payload: payload} }

  before do
    post params.to_param, 'Content-Type' => 'application/x-www-form-urlencoded'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        <b>Jul 30 01:13:56 idobata heroku/router:</b>
        POST esm.idobata.io/rooms/6/hooks/13 dyno=web.1 queue=0 wait=0ms service=200ms status=200 bytes=1
      </p>
      <p>
        <b>Jul 30 01:13:56 idobata app/web.1:</b>
        Started POST &quot;/rooms/6/hooks/13&quot; for 67.214.223.21 at 2012-07-30 08:13:56 +0000
      </p>
    HTML

    its([:format]) { should eq(:html) }
  end
end
