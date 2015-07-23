require 'spec_helper'

describe Idobata::Hook::Bitbucket, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    let(:payload) { fixture_payload("bitbucket/services/#{event_type}.json") }

    describe 'POST hook' do
      let(:params) { {payload: payload} }

      before do
        post params.to_param, 'Content-Type' => 'application/x-www-form-urlencoded'
      end

      describe 'push event' do
        let(:event_type) { 'push' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <a href='https://bitbucket.org/tricknotes'>tricknotes</a>
          pushed to
          <a href='https://bitbucket.org/ursm/hello/'>ursm/hello</a>
          <ul>
            <li>
              <a href='https://bitbucket.org/ursm/hello/commits/b1e452d885d6'><tt>b1e452d</tt></a>
              hi
            </li>
          </ul>
        HTML
      end
    end

    describe 'Pull Request POST hook' do
      before do
        post payload, 'Content-Type' => 'application/json'
      end

      describe 'pullrequest_created event' do
        let(:event_type) { 'pullrequest_created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F9d3d19e361c2%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/tricknotes'>
              Ryunosuke SATO
            </a>
            created pull request to
            <a href='https://bitbucket.org/ursm/hello/pull-request/13'>
              ursm/hello#13
            </a>
            <b>ping!</b>
          </p>
          <h1>This is a pull request</h1>

          <ul>
          <li>hi</li>
          <li>hoi</li>
          <li>yo</li>
          </ul>
        HTML
      end

      describe 'pullrequest_merged event' do
        let(:event_type) { 'pullrequest_merged' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F9d3d19e361c2%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/tricknotes'>Ryunosuke SATO</a>
            merged pull request.
            <b>ping!</b>
          </p>
        HTML
      end

      describe 'pullrequest_updated event' do
        let(:event_type) { 'pullrequest_updated' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F9d3d19e361c2%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/tricknotes'>Ryunosuke SATO</a>
            updated pull request.
            <b>ping!</b>
          </p>
          <h1>This is a pull request</h1>

          <div class="highlight highlight-ruby"><pre><span class="k">def</span> <span class="nf">hell</span>
            <span class="ss">:hi</span>
          <span class="k">end</span>
          </pre></div>
        HTML
      end

      describe 'pullrequest_declined event' do
        let(:event_type) { 'pullrequest_declined' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <p>
            <span>
              <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2F9d3d19e361c2%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
            </span>
            <a href='https://bitbucket.org/tricknotes'>Ryunosuke SATO</a>
            declined pull request.
            <b>ping!</b>
          </p>
        HTML
      end

      describe 'pullrequest comment created event' do
        let(:event_type) { 'pullrequest_comment_created' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span>
            <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2Fd7db0fdaad19%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
          </span>
          <a href='https://bitbucket.org/tricknotes'>Ryunosuke SATO</a>
          commented on pull request
          <a href='https://bitbucket.org/ursm/hello/pull-request/20/_/diff#comment-1236863'>ursm/hello#20</a>
          <div class='bitbucket-html'><p>+1 for me</p></div>
        HTML
      end

      describe 'pullrequest_comment_updated event' do
        let(:event_type) { 'pullrequest_comment_updated' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span>
            <img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https%3A%2F%2Fd3oaxc4q5k2d6q.cloudfront.net%2Fm%2Fe6bd9f5793a0%2Fimg%2Fdefault_avatar%2F32%2Fuser_blue.png&amp;s=32" width="16" height="16" alt="" />
          </span>
          <a href='https://bitbucket.org/tricknotes'>Ryunosuke SATO</a>
          updated comment on pull request
          <a href='https://bitbucket.org/tricknotes/notification-test/pull-request/11/_/diff#comment-1316114'>tricknotes/notification-test#11</a>
          <div class='bitbucket-html'><p>updated!</p></div>
        HTML
      end

      describe 'pullrequest approve event' do
        let(:event_type) { 'pullrequest_approve' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'pullrequest_comment_deleted event' do
        let(:event_type) { 'pullrequest_comment_deleted' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end
    end
  end
end
