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
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/1796864?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/mtsmfm'>mtsmfm</a>
            pushed to
            <a href='https://github.com/mtsmfm/notificaiton-test/tree/master'>master</a>
            at
            <a href='https://github.com/mtsmfm/notificaiton-test'>mtsmfm/notificaiton-test</a>
            (<a href='https://github.com/mtsmfm/notificaiton-test/compare/a61d33c7ca88...fe77ebad85c4'>compare</a>)
          </div>
          <ul>
            <li>
              <a href='https://github.com/mtsmfm/notificaiton-test/commit/ddccd1ccfb871dc798ae903021e5ad7e22c78326'><tt>ddccd1c</tt></a>
              Remove line
              
            </li>
            <li>
              <a href='https://github.com/mtsmfm/notificaiton-test/commit/fe77ebad85c4557f944174fcb8bf14eace15840d'><tt>fe77eba</tt></a>
              Add line
              
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
          <div>Ping from GitHub received. Your hook seems to be successfully configured.</div>
        HTML

        its([:format]) { should eq(:html) }
      end

      describe 'push event with long comment' do
        let(:fixture)           { 'push_with_long_comment.json' }
        let(:github_event_type) { 'push' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/1796864?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/mtsmfm'>mtsmfm</a>
            pushed to
            <a href='https://github.com/mtsmfm/notificaiton-test/tree/master'>master</a>
            at
            <a href='https://github.com/mtsmfm/notificaiton-test'>mtsmfm/notificaiton-test</a>
            (<a href='https://github.com/mtsmfm/notificaiton-test/compare/538961d8584d...a61d33c7ca88'>compare</a>)
          </div>
          <ul>
            <li>
              <a href='https://github.com/mtsmfm/notificaiton-test/commit/a61d33c7ca88593da023964423c721e66fcd2228'><tt>a61d33c</tt></a>
              commit comment with newlines
              <p>hi<br>
              :smile:<br>
              see: #1</p>
            </li>
          </ul>
        HTML
      end

      describe 'push with branch including fragment hash' do
        let(:fixture)           { 'push_with_branch_including_fragment_hash.json' }
        let(:github_event_type) { 'push' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            pushed to
            <a href='https://github.com/idobata/idobata-hooks/tree/welcome%23index'>welcome#index</a>
            at
            <a href='https://github.com/idobata/idobata-hooks'>idobata/idobata-hooks</a>
            (<a href='https://github.com/idobata/idobata-hooks/compare/9a8aebeacabc...586d5918dc26'>compare</a>)
          </div>
          <ul>
            <li>
              <a href='https://github.com/idobata/idobata-hooks/commit/586d5918dc260a42bcf6be302893de0e561737ea'><tt>586d591</tt></a>
              Hi
              
            </li>
          </ul>
        HTML
      end

      describe 'branch (including fragment hash) create event' do
        let(:fixture)           { 'create_branch_including_fragment_hash.json' }
        let(:github_event_type) { 'create' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            created branch
            <a href='https://github.com/idobata/idobata-hooks/tree/welcome%23index'>welcome#index</a>
            at
            <a href='https://github.com/idobata/idobata-hooks'>idobata/idobata-hooks</a>
          </div>
        HTML
      end

      describe 'tag create event' do
        let(:fixture)           { 'tag_create.json' }
        let(:github_event_type) { 'create' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            created tag
            <a href='https://github.com/tricknotes/notification-test/tree/hoi'>hoi</a>
            at
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
          </div>
        HTML
      end

      describe 'tag delete event' do
        let(:fixture)           { 'tag_delete.json' }
        let(:github_event_type) { 'delete' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            deleted tag 168 at
            <a href='https://github.com/tricknotes/notification-test'>tricknotes/notification-test</a>
          </div>
        HTML
      end

      describe 'issue event' do
        let(:fixture)           { 'issue.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            opened issue
            <a href='https://github.com/tricknotes/notification-test/issues/10'>tricknotes/notification-test#10</a>
            <b>issue opened</b>
          </div>
          <p>This is a issue.<br>
          <code>puts :hi</code></p>
        HTML
      end

      describe 'issue (closed) event' do
        let(:fixture)           { 'issue_closed.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            closed issue
            <a href='https://github.com/tricknotes/notification-test/issues/10'>tricknotes/notification-test#10</a>
            <b>Oops!!</b>
          </div>

        HTML
      end

      describe 'issue (labeled) event' do
        let(:fixture)           { 'issue_labeled.json' }
        let(:github_event_type) { 'issues' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            labeled
            <span class='label' style='background-color: #84b6eb; color: #1c2733;'>enhancement</span>
            to
            <a href='https://github.com/idobata/idobata-hooks/issues/14'>idobata/idobata-hooks#14</a>
            <b>Need more kindness info about GitHub events</b>
          </div>

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
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            assigned
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            to
            <a href='https://github.com/idobata/idobata-hooks/issues/14'>idobata/idobata-hooks#14</a>
            <b>Need more kindness info about GitHub events</b>
          </div>

        HTML
      end

      describe 'pull request event' do
        let(:fixture)           { 'pull_request.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            opened pull request
            <a href='https://github.com/tricknotes/notification-test/pull/2'>tricknotes/notification-test#2</a>
            <b>Test for PR</b>
          </div>
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
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            closed pull request
            <a href='https://github.com/tricknotes/notification-test/pull/12'>tricknotes/notification-test#12</a>
            <b>:soy_milk:</b>
          </div>
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
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            labeled
            <span class='label' style='background-color: #84b6eb; color: #1c2733;'>enhancement</span>
            to
            <a href='https://github.com/idobata/idobata-hooks/pull/16'>idobata/idobata-hooks#16</a>
            <b>[WIP] Support to show Github PR's label name and assignee</b>
          </div>

        HTML
      end

      describe 'pull request (assigned) event' do
        let(:fixture)           { 'pull_request_assigned.json' }
        let(:github_event_type) { 'pull_request' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            assigned
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            to
            <a href='https://github.com/idobata/idobata-hooks/pull/16'>idobata/idobata-hooks#16</a>
            <b>[WIP] Support to show Github PR's label name and assignee</b>
          </div>

        HTML
      end

      context 'pull request comment event' do
        let(:fixture)           { 'pull_request_comment.json' }
        let(:github_event_type) { 'issue_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on pull request
            <a href='https://github.com/tricknotes/notification-test/issues/2#issuecomment-19731401'>tricknotes/notification-test#2</a>
            <b>Test for PR</b>
          </div>
          <p>This is a comment :smile: </p>
        HTML
      end

      context 'issue comment create event' do
        let(:fixture)           { 'issue_comment.json' }
        let(:github_event_type) { 'issue_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on issue
            <a href='https://github.com/tricknotes/notification-test/issues/21#issuecomment-39527529'>tricknotes/notification-test#21</a>
            <b>Hey!</b>
          </div>
          <p>mottomotto</p>
        HTML
      end

      describe 'issue comment delete event' do
        let(:fixture)           { 'issue_comment_delete.json' }
        let(:github_event_type) { 'issue_comment' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      context 'pull request review comment event' do
        let(:fixture)           { 'pull_request_review_comment.json' }
        let(:github_event_type) { 'pull_request_review_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on pull request
            <a href='https://github.com/tricknotes/notification-test/pull/5#discussion_r4791306'>tricknotes/notification-test#5</a>
          </div>
          <p>:angel: :innocent: :angel: </p>
        HTML
      end

      context 'pull request review comment edited event' do
        let(:fixture)           { 'pull_request_review_comment_edited.json' }
        let(:github_event_type) { 'pull_request_review_comment' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      context 'pull request review event (commented)' do
        let(:fixture)           { 'pull_request_review_commented.json' }
        let(:github_event_type) { 'pull_request_review' }

        its([:source]) { should eq(<<~HTML) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/17717895?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/obatan'>obatan</a>
            commented on pull request
            <a href='https://github.com/idobata/idobata-hooks/pull/73#pullrequestreview-4794622'>idobata/idobata-hooks#73</a>
            <b>Collecting review-event payload</b>
          </div>
          <p>leaving a review comment</p>
        HTML
      end

      context 'pull request review event (commented but no body)' do
        let(:fixture)           { 'pull_request_review_commented_with_no_body.json' }
        let(:github_event_type) { 'pull_request_review' }

        subject { ->{ hook.process_payload } }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      context 'pull request review event (approved)' do
        let(:fixture)           { 'pull_request_review_approved.json' }
        let(:github_event_type) { 'pull_request_review' }

        its([:source]) { should eq(<<~HTML) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/17717895?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/obatan'>obatan</a>
            approved pull request
            <a href='https://github.com/idobata/idobata-hooks/pull/73#pullrequestreview-4794931'>idobata/idobata-hooks#73</a>
            <b>Collecting review-event payload</b>
          </div>
          <p>I'd like to approve this :robot: </p>
        HTML
      end

      context 'pull request review event (changes_requested)' do
        let(:fixture)           { 'pull_request_review_changes_requested.json' }
        let(:github_event_type) { 'pull_request_review' }

        its([:source]) { should eq(<<~HTML) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/17717895?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/obatan'>obatan</a>
            requested changes on pull request
            <a href='https://github.com/idobata/idobata-hooks/pull/73#pullrequestreview-4794838'>idobata/idobata-hooks#73</a>
            <b>Collecting review-event payload</b>
          </div>
          <p>We'd like to change ...</p>
        HTML
      end

      context 'commit comment event' do
        let(:fixture)           { 'commit_comment.json' }
        let(:github_event_type) { 'commit_comment' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://secure.gravatar.com/avatar/dc03a27ae31ba428c560c00c9128cd75?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            commented on commit
            <a href='https://github.com/tricknotes/notification-test/commit/6c2eacbf8ef360a90508383574e488c3db67caf5#commitcomment-3685259'>tricknotes/notification-test@6c2eacb</a>
          </div>
          <p>This is a commit comment!</p>
        HTML
      end

      context 'gollum event' do
        let(:fixture)           { 'gollum.json' }
        let(:github_event_type) { 'gollum' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
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
          </div>
        HTML
      end

      describe 'watch event' do
        let(:fixture)           { 'watch.json' }
        let(:github_event_type) { 'watch' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/290782?v=2" width="16" height="16" alt="" /></span>
            <a href='https://github.com/tricknotes'>tricknotes</a>
            starred
            <a href='https://github.com/idobata/capybara_screenshot_idobata'>idobata/capybara_screenshot_idobata</a>
          </div>
        HTML
      end

      describe 'repository event' do
        let(:fixture)           { 'repository.json' }
        let(:github_event_type) { 'repository' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            <span><img src="https://avatars.githubusercontent.com/u/7548?v=3" width="16" height="16" alt="" /></span>
            <a href='https://github.com/ursm'>ursm</a>
            created repository
            <a href='https://github.com/idobata/flexing'>idobata/flexing</a>
          </div>
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
          <div>
            The Travis CI build passed: idobata/idobata-hooks
            (<a href='https://travis-ci.org/idobata/idobata-hooks/builds/36738881'>build</a>)
            :
            <span class='label label-success'>
              Success
            </span>
          </div>
          <div>
            Keita Urashima: Merge pull request #18 from idobata/github-status-event
            (<a href='https://github.com/idobata/idobata-hooks/commit/433db95a768426ecf7ac77a9ef1ad9a3b0557367'>433db95a</a>)
          </div>
        HTML
      end

      describe 'status event as failure' do
        let(:fixture)           { 'status_failure.json' }
        let(:github_event_type) { 'status' }

        its([:source]) { should eq(<<-HTML.strip_heredoc) }
          <div>
            The Travis CI build failed: idobata/idobata-hooks
            (<a href='https://travis-ci.org/idobata/idobata-hooks/builds/36560867'>build</a>)
            :
            <span class='label label-danger'>
              Failure
            </span>
          </div>
          <div>
            Ryunosuke SATO: WIP: Support GitHub's status event
            (<a href='https://github.com/idobata/idobata-hooks/commit/d4fcd0513cfce99f646b9f18e351a68bf9476fe6'>d4fcd051</a>)
          </div>
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
