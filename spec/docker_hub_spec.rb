describe Idobata::Hook::DockerHub, type: :hook do
  let(:payload) { fixture_payload('docker_hub.json') }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <div>
        hanachin pushed <a href="https://hub.docker.com/r/hanachin/tmp_docker_hub_webhook">hanachin/tmp_docker_hub_webhook</a>:latest
      </div>
    HTML
    its([:format]) { should eq(:html) }
  end
end
