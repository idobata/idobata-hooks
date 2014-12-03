require 'spec_helper'

describe Idobata::Hook::Airbrake, type: :hook do
  let(:payload) { fixture_payload("airbrake/error.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    it { expect(subject[:source]).to be_present }
    it { expect(subject[:images]).to be_nil }
    it { expect(subject[:format]).to eq(:html) }
  end
end
