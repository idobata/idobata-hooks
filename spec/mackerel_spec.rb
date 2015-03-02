require 'spec_helper'

describe Idobata::Hook::Mackerel, type: :hook do
  let(:payload) { fixture_payload("mackerel/#{payload_type}.json") }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on alert' do
      let(:payload_type) { 'alert' }
      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span class='label label-important'>CRITICAL</span>
          connectivity at app01 (working) Service: role
          (<a href='https://mackerel.io/orgs/.../alerts/2bj...'>detail</a>)
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on sample' do
      let(:payload_type) { 'sample' }
      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          sample: Sample Notification from Mackerel
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
