describe Idobata::Hook::CircleCI, type: :hook do
  let(:payload) { fixture_payload('circle_ci.json') }

  before do
    post payload, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }

    its([:source]) { should eq(<<-HTML.strip_heredoc) }
      <div>
        circleci/mongofinil<a href='https://circleci.com/gh/circleci/mongofinil/22'>#22</a>
        (master - <tt>1d23162</tt>):
        <span class='label label-success'>Success</span>
        (Finished in 23 seconds)
      </div>
      <div>
        Allen Rohner: Don't explode when the system clock shifts backwards
        (<a href='https://github.com/circleci/mongofinil/compare/0553ba86b3...1d231626ba1d'>changeset</a>)
      </div>
    HTML

    its([:format]) { should eq(:html) }
  end
end
