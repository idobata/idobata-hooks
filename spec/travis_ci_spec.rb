require 'spec_helper'

describe Idobata::Hook::TravisCI, type: :hook do
  let(:payload) { fixture_payload('travis_ci.json') }
  let(:params)  { {payload: payload} }

  before do
    post params.to_param, 'Content-Type' => 'application/x-www-form-urlencoded'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    its([:source]) { should eq(<<-HTML.strip_heredoc) }
      <p>
        esminc/idobata<a href='https://magnum.travis-ci.com/esminc/idobata/builds/2663'>#124</a>
        (travis-ci-integration - <span class="commit-id">25d6fc1</span>):
        <span class='label label-success'>Passed</span>
        (Finished in 86 seconds)
      </p>
      <p>
        hibariya: (test) hook!
        (<a href='https://github.com/esminc/idobata/compare/676b88ee9966...25d6fc1811e3'>changeset</a>)
      </p>
    HTML

    its([:format]) { should eq(:html) }
  end
end
