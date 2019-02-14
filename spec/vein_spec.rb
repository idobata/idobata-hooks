describe Idobata::Hook::Vein, type: :hook do
  let(:payload) { fixture_payload('vein.json') }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <img height='16' src='https://www.gravatar.com/avatar/a51816c3b11f79d9644a46105d513f1b?default=identicon&s=48' width='16'>
      <b>niku starred</b>
      <br>
      Elixir v1.8 released
      <br>
      https://elixir-lang.org/blog/2019/01/14/elixir-v1-8-0-released/
    HTML

    its([:format]) { should eq(:html) }
  end
end
