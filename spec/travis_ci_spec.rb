describe Idobata::Hook::TravisCI, type: :hook do
  let(:payload) { fixture_payload('travis_ci.json') }
  let(:params)  { {payload: payload} }

  before do
    post params.to_param, 'Content-Type' => 'application/x-www-form-urlencoded'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <div>
        esminc/idobata<a href='https://magnum.travis-ci.com/esminc/idobata/builds/2663'>#124</a>
        (travis-ci-integration - <tt>25d6fc1</tt>):
        <span class='label label-success'>Passed</span>
        (Finished in 86 seconds)
      </div>
      <div>
        hibariya: (test) hook!
        (<a href='https://github.com/esminc/idobata/compare/676b88ee9966...25d6fc1811e3'>changeset</a>)
      </div>
    HTML

    its([:format]) { should eq(:html) }
  end
end
