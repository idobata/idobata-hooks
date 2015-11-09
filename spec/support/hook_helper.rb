require 'active_support/hash_with_indifferent_access'

module HookHelper
  def self.included(base)
    base.subject { hook }

    base.let(:hook) { @hook }
  end

  def post(raw_body, headers = {}, params = {})
    @hook = described_class.new(raw_body, Rack::Utils::HeaderHash.new(headers), ActiveSupport::HashWithIndifferentAccess.new(params))
  end

  def fixture_payload(filename)
    Idobata::Hook.root.join('../spec/fixtures/payload', filename).read
  end
end
