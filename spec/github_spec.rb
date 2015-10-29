describe Idobata::Hook::Github, type: :hook do
  let(:payload) { fixture_payload("github/#{fixture}") }

  describe '#process_payload' do
    subject { hook.process_payload }

    describe 'paylaod encoded as "application/x-www-form-urlencoded"' do
      let(:params) { {payload: payload} }

      before do
        post params.to_param,
          'Content-Type'   => 'application/x-www-form-urlencoded; charset=utf-8',
          'X-GitHub-Event' => github_event_type
      end

      describe 'push event' do
        let(:fixture)           { 'push.json' }
        let(:github_event_type) { 'push' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/f966e93db0fbaf3aa07f7df5fa136933?s=32&amp;d=mm" width="16" height="16" alt="" /></span>
            <a href='https://github.com/ursm'>ursm</a>
            pushed to
            <a href='https://github.com/esminc/idobata/tree/foo/bar'>foo/bar</a>
            at
            <a href='https://github.com/esminc/idobata'>esminc/idobata</a>
            (<a href='https://github.com/esminc/idobata/compare/359eaf8de7c3...9f5102f9c212'>compare</a>)
          </p>
          <ul>
            <li>
              <a href='https://github.com/esminc/idobata/commit/dc98741098f3fc245055ff76571dc1a257ccfc35'><tt>dc98741</tt></a>
              add validations to User#name
              
            </li>
            <li>
              <a href='https://github.com/esminc/idobata/commit/9f5102f9c2129a14577fd8c17bb55526547a5642'><tt>9f5102f</tt></a>
              give over to html5_validations
              
            </li>
          </ul>
        HTML

        its([:format]) { should eq(:html) }
      end
    end

    describe 'paylaod encoded as "application/vnd.github.v3+json"' do
      before do
        post payload,
          'Content-Type'   => 'application/json',
          'X-GitHub-Event' => github_event_type
      end

      describe 'ping event' do
        let(:fixture)           { 'ping.json' }
        let(:github_event_type) { 'ping' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>Ping from GitHub received. Your hook seems to be successfully configured.</p>
        HTML

        its([:format]) { should eq(:html) }
      end

      describe 'push event with long comment' do
        let(:fixture)           { 'push_with_long_comment.json' }
        let(:github_event_type) { 'push' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=32&amp;d=mm" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            pushed to
            <a href='https://github.com/tricknotes/notification-test/tree/master'>master</a>
            at
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
            (<a href='https://github.com/tricknotes/notification-test/compare/82e1f8ee0d69...24b298f847d9'>compare</a>)
          </p>
          <ul>
            <li>
              <a href='https://github.com/tricknotes/notification-test/commit/24b298f847d9bd36246fd3da5b6ff1bce90f362e'><tt>24b298f</tt></a>
              commit comment with newlines
              <p>hi<br>
              :smile:<br>
              see: #1</p>
            </li>
          </ul>
        HTML
      end

      describe 'tag create event' do
        let(:fixture)           { 'tag_create.json' }
        let(:github_event_type) { 'create' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            created tag
            <a href='https://github.com/tricknotes/notification-test/tree/hoi'>hoi</a>
            at
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
          </p>
        HTML
      end

      describe 'tag delete event' do
        let(:fixture)           { 'tag_delete.json' }
        let(:github_event_type) { 'delete' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            deleted tag 168 at
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
          </p>
        HTML
      end

      describe 'issue event' do
        let(:fixture)           { 'issue.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            opened issue
            <a href='https://github.com/tricknotes/notification-test/issues/10'>tricknotes/notification-test#10</a>
            <b>issue opened</b>
          </p>
          <p>This is a issue.<br>
          <code>puts :hi</code></p>
        HTML
      end

      describe 'issue (closed) event' do
        let(:fixture)           { 'issue_closed.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            closed issue
            <a href='https://github.com/tricknotes/notification-test/issues/10'>tricknotes/notification-test#10</a>
            <b>Oops!!</b>
          </p>

        HTML
      end

      describe 'issue (labeled) event' do
        let(:fixture)           { 'issue_labeled.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            labeled
            <span class='label' style='background-color: #84b6eb; color: #1c2733;'>enhancement</span>
            to
            <a href='https://github.com/idobata/idobata-hooks/issues/14'>idobata/idobata-hooks#14</a>
            <b>Need more kindness info about GitHub events</b>
          </p>

        HTML
      end

      describe 'issue (delete label as unlabeled) event' do
        let(:fixture)           { 'issue_label_deleted.json' }
        let(:github_event_type) { 'issues' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'issue (assigned) event' do
        let(:fixture)           { 'issue_assigned.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            assigned
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            to
            <a href='https://github.com/idobata/idobata-hooks/issues/14'>idobata/idobata-hooks#14</a>
            <b>Need more kindness info about GitHub events</b>
          </p>

        HTML
      end

      describe 'pull request event' do
        let(:fixture)           { 'pull_request.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            opened pull request
            <a href='https://github.com/tricknotes/notification-test/pull/2'>tricknotes/notification-test#2</a>
            <b>Test for PR</b>
          </p>
          <div class='pull-info'>
            <b>1</b>
            commit
            with
            <b>1</b>
            addition
            and
            <b>2</b>
            deletions
          </div>
          <p>This is a pull request</p>

          <ul>
          <li>ok</li>
          </ul>
        HTML
      end

      describe 'pull request (closed) event' do
        let(:fixture)           { 'pull_request_closed.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            closed pull request
            <a href='https://github.com/tricknotes/notification-test/pull/12'>tricknotes/notification-test#12</a>
            <b>:soy_milk:</b>
          </p>
          <div class='pull-info'>
            <b>1</b>
            commit
            with
            <b>1</b>
            addition
            and
            <b>5</b>
            deletions
          </div>

        HTML
      end

      describe 'pull request (labeled) event' do
        let(:fixture)           { 'pull_request_labeled.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            labeled
            <span class='label' style='background-color: #84b6eb; color: #1c2733;'>enhancement</span>
            to
            <a href='https://github.com/idobata/idobata-hooks/pull/16'>idobata/idobata-hooks#16</a>
            <b>[WIP] Support to show Github PR's label name and assignee</b>
          </p>

        HTML
      end

      describe 'pull request (assigned) event' do
        let(:fixture)           { 'pull_request_assigned.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            assigned
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            to
            <a href='https://github.com/idobata/idobata-hooks/pull/16'>idobata/idobata-hooks#16</a>
            <b>[WIP] Support to show Github PR's label name and assignee</b>
          </p>

        HTML
      end

      context 'pull request comment event' do
        let(:fixture)           { 'pull_request_comment.json' }
        let(:github_event_type) { 'issue_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on pull request
            <a href='https://github.com/tricknotes/notification-test/issues/2#issuecomment-19731401'>tricknotes/notification-test#2</a>
            <b>Test for PR</b>
          </p>
          <p>This is a comment :smile: </p>
        HTML
      end

      context 'issue comment event' do
        let(:fixture)           { 'issue_comment.json' }
        let(:github_event_type) { 'issue_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on issue
            <a href='https://github.com/tricknotes/notification-test/issues/21#issuecomment-39527529'>tricknotes/notification-test#21</a>
            <b>Hey!</b>
          </p>
          <p>mottomotto</p>
        HTML
      end

      context 'pull request review comment event' do
        let(:fixture)           { 'pull_request_review_comment.json' }
        let(:github_event_type) { 'pull_request_review_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on pull request
            <a href='https://github.com/tricknotes/notification-test/pull/5#discussion_r4791306'>tricknotes/notification-test#5</a>
          </p>
          <p>:angel: :innocent: :angel: </p>
        HTML
      end

      context 'commit comment event' do
        let(:fixture)           { 'commit_comment.json' }
        let(:github_event_type) { 'commit_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on commit
            <a href='https://github.com/tricknotes/notification-test/commit/6c2eacbf8ef360a90508383574e488c3db67caf5#commitcomment-3685259'>tricknotes/notification-test@6c2eacb</a>
          </p>
          <p>This is a commit comment!</p>
        HTML
      end

      context 'gollum event' do
        let(:fixture)           { 'gollum.json' }
        let(:github_event_type) { 'gollum' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            edited the
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
            wiki
            <ul>
              <li>
                Edited <a href="https://github.com/tricknotes/notification-test/wiki/About-wiki">About wiki</a>.
                <a href='https://github.com/tricknotes/notification-test/wiki/About-wiki/_compare/35da4ba^...35da4ba'>View the diff &raquo;</a>
              </li>
            </ul>
          </p>
        HTML
      end

      describe 'watch event' do
        let(:fixture)           { 'watch.json' }
        let(:github_event_type) { 'watch' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            starred
            <a href='https://github.com/idobata/capybara_screenshot_idobata'>idobata/capybara_screenshot_idobata</a>
          </p>
        HTML
      end

      describe 'repository event' do
        let(:fixture)           { 'repository.json' }
        let(:github_event_type) { 'repository' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            <span><img src="https://avatars.githubusercontent.com/u/7548?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/ursm'>ursm</a>
            created repository
            <a href='https://github.com/idobata/flexing'>idobata/flexing</a>
          </p>
        HTML
      end

      describe 'status event as pending' do
        let(:fixture)           { 'status_pending.json' }
        let(:github_event_type) { 'status' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'status event as success' do
        let(:fixture)           { 'status_success.json' }
        let(:github_event_type) { 'status' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            The Travis CI build passed: idobata/idobata-hooks
            (<a href='https://travis-ci.org/idobata/idobata-hooks/builds/36738881'>build</a>)
            :
            <span class='label label-success'>
              Success
            </span>
          </p>
          <p>
            Keita Urashima: Merge pull request #18 from idobata/github-status-event
            (<a href='https://github.com/idobata/idobata-hooks/commit/433db95a768426ecf7ac77a9ef1ad9a3b0557367'>433db95a</a>)
          </p>
        HTML
      end

      describe 'status event as failure' do
        let(:fixture)           { 'status_failure.json' }
        let(:github_event_type) { 'status' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <p>
            The Travis CI build failed: idobata/idobata-hooks
            (<a href='https://travis-ci.org/idobata/idobata-hooks/builds/36560867'>build</a>)
            :
            <span class='label label-danger'>
              Failure
            </span>
          </p>
          <p>
            Ryunosuke SATO: WIP: Support GitHub's status event
            (<a href='https://github.com/idobata/idobata-hooks/commit/d4fcd0513cfce99f646b9f18e351a68bf9476fe6'>d4fcd051</a>)
          </p>
        HTML
      end

      describe 'branch deleted as push event' do
        let(:fixture)           { 'branch_deleted_as_push.json' }
        let(:github_event_type) { 'push' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'pull request (synchronize) event' do
        let(:fixture)           { 'pull_request_synchronize.json' }
        let(:github_event_type) { 'pull_request' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'Without X-GitHub-Event' do
        let(:fixture)           { 'ping.json' }
        let(:github_event_type) { nil }

        subject { -> { hook.process_payload } }

        it { should raise_error(Idobata::Hook::BadRequest, 'This is GitHub hook, who are you?') }
      end
    end
  end
end
