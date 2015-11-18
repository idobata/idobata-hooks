describe Idobata::Hook::Bitbucket, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    let(:payload) { fixture_payload("bitbucket/#{event_type.sub(/:/, '_')}.json") }

    before do
      post payload, 'Content-Type' => 'application/json', 'X-Event-Key' => event_type
    end

    describe 'POST hook' do
      describe 'push event' do
        let(:event_type) { 'repo:push' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <a href='https://bitbucket.org/hibariya'>hibariya</a>
          pushed to
          <a href='https://bitbucket.org/hibariya/test'>hibariya/test</a>
          <ul>
            <li>
              <a href='https://bitbucket.org/hibariya/test/branches/compare/725b0f6ffbc616ddce92602fa3ad88d9e61a81db..636f8eb6548e819f6ea7b0e3bf59e43b03ec2709'><tt>725b0f6</tt></a>
              Improve README
            </li>
          </ul>
        HTML
      end

      describe 'fork event' do
        let(:event_type) { 'repo:fork' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <a href='https://bitbucket.org/masumiya'>masumiya</a>
          fork from
          <a href='https://bitbucket.org/masumiya/test'>masumiya/test</a>
          to
          <a href='https://bitbucket.org/forked_user/test'>forked_usertest/test</a>
        HTML
      end

      describe 'commit comment created event' do
        let(:event_type) { 'repo:commit_comment_created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/masumiya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/masumiya'>
              Yuichi Masumiya
            </a>
            created commit comment to
            <a href='https://bitbucket.org/masumiya/test/issues/1#comment-23357395'>
              17
            </a>
          </p>
          <p>Comment text</p>
        HTML
      end
    end

    describe 'Pull Request POST hook' do

      describe 'pullrequest:created event' do
        let(:event_type) { 'pullrequest:created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/ursm/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/ursm'>
              Keita Urashima
            </a>
            created pull request to
            <a href='https://bitbucket.org/hibariya/test/pull-request/1'>
              hibariya/test#1
            </a>
            <b>This is ursm</b>
          </p>
          <p>hi</p>
        HTML
      end

      describe 'pullrequest:fulfilled event' do
        let(:event_type) { 'pullrequest:fulfilled' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/hibariya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/hibariya'>hibariya</a>
            merged pull request
            <a href='https://bitbucket.org/hibariya/test/pull-request/2'>
              hibariya/test#2
            </a>
          </p>
        HTML
      end

      describe 'pullrequest:rejected event' do
        let(:event_type) { 'pullrequest:rejected' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/hibariya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/hibariya'>hibariya</a>
            declined pull request
            <a href='https://bitbucket.org/hibariya/test/pull-request/1'>
              hibariya/test#1
            </a>
          </p>
        HTML
      end

      describe 'pullrequest comment created event' do
        let(:event_type) { 'pullrequest:comment_created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span>
            <img src="https://bitbucket.org/account/hibariya/avatar/32/" width="16" height="16" alt="" />
          </span>
          <a href='https://bitbucket.org/hibariya'>hibariya</a>
          commented on pull request
          <a href='https://bitbucket.org/hibariya/test/pull-request/1/_/diff#comment-8475483'>hibariya/test#1</a>
          <div class='bitbucket-html'><p>That is ursm!</p></div>
        HTML
      end

      describe 'pullrequest approve event' do
        let(:event_type) { 'pullrequest:approved' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/hibariya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/hibariya'>hibariya</a>
            approved pull request
            <a href='https://bitbucket.org/hibariya/test/pull-request/1'>
              hibariya/test#1
            </a>
          </p>
        HTML
      end

      describe 'pullrequest unapprove event' do
        let(:event_type) { 'pullrequest:unapproved' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/masumiya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/masumiya'>masumiya</a>
            unapproved pull request
            <a href='https://bitbucket.org/masumiya/test/pull-request/1'>
              masumiya/test#1
            </a>
          </p>
        HTML
      end
    end

    describe 'Issue POST hook' do
      context 'created' do
        let(:event_type) { 'issue:created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/masumiya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/masumiya'>
              Yuichi Masumiya
            </a>
            created issue to
            <a href='https://bitbucket.org/masumiya/test/issues/1'>
              issue test#1
            </a>
            <b>issue test</b>
          </p>
          <p>Issue description</p>
        HTML
      end

      context 'updated' do
        let(:event_type) { 'issue:updated' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/masumiya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/masumiya'>
              Yuichi Masumiya
            </a>
            updated issue to
            <a href='https://bitbucket.org/masumiya/test/issues/1'>
              issue test#1
            </a>
            <b>issue test</b>
          </p>
        HTML
      end

      context 'comment created' do
        let(:event_type) { 'issue:comment_created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://bitbucket.org/account/masumiya/avatar/32/" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/masumiya'>
              Yuichi Masumiya
            </a>
            created issue comment to
            <a href='https://bitbucket.org/masumiya/test/issues/1#comment-23357395'>
              17
            </a>
          </p>
          <p>Comment text</p>
        HTML
      end
    end
  end
end
