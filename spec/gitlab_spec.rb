describe Idobata::Hook::Gitlab, type: :hook do
  let(:payload) { fixture_payload("gitlab/#{fixture}") }
  let(:params)  { JSON.parse(payload) }

  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    describe 'push event' do
      let(:fixture) { 'push.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span>John Smith</span>
          pushed to
          <a href='http://example.com/diaspora/tree/master'>master</a>
          at
          <a href='http://example.com/diaspora'>diaspora</a>
          (<a href='http://example.com/diaspora/compare/95790bf891e76fee5e1747ab589903a6a1f80f22...da1560886d4f094c3e6c9ef40349f7d38b5d27d7'>compare</a>)
        </div>
        <ul>
          <li>
            <a href='http://example.com/diaspora/commits/b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327'><tt>b6568db</tt></a>
            Update Catalan translation to e38cb41.
            
          </li>
          <li>
            <a href='http://example.com/diaspora/commits/da1560886d4f094c3e6c9ef40349f7d38b5d27d7'><tt>da15608</tt></a>
            fixed readme
            <h1>hi</h1>
            <ul>
            <li>hoi</li>
            <li>hoi</li>
            </ul>
          </li>
        </ul>
      HTML
    end

    describe 'tag event' do
      let(:fixture) { 'tag.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span>tricknotes</span>
          created tag
          <a href='http://example.com/tricknotes/test/commits/hi'>hi</a>
          at
          <a href='http://example.com/tricknotes/test'>tricknotes/test</a>
        </div>
      HTML
    end

    describe 'issue event' do
      let(:fixture) { 'issue.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Ryunosuke SATO
          closed
          issue
          <a href='https://gitlab.com/tricknotes/test/issues/1'>tricknotes#1</a>
          <b>This is a new issue.</b>
        </div>

      HTML
    end

    describe 'old issue event (Gitlab 7.0.0)' do
      let(:fixture) { 'issue-7.0.0.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          The issue was reopened:
          #2
          <b>hoihoi</b>
        </div>

      HTML
    end

    describe 'merge request event' do
      let(:fixture) { 'merge_request.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Ryunosuke SATO
          opened
          merge request
          <a href='https://gitlab.com/tricknotes/test/merge_requests/1'>tricknotes/test#1</a>
          <b>Ping</b>
        </div>
      HTML
    end

    describe 'old merge request event (Gitlab 7.0.0)' do
      let(:fixture) { 'merge_request-7.0.0.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
       <div>
         The merge request was closed:
         <b>Ping!</b>
       </div>
      HTML
    end

    describe 'project create event' do
      let(:fixture) { 'project_create.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        The new project <b>alice/hoi</b> is created.
      HTML
    end

    describe 'issue comment event' do
      let(:fixture) { 'issue_comment.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Tester
          commented on
          issue
          <a href='https://gitlab.com/trickcomments/test/issues/29#note_53469'>trickcomments#29</a>
          <b>Connect to Idobata(Issue)</b>
        </div>
        <p>
          This is a new comment.
        </p>
      HTML
    end

    describe 'merge request comment event' do
      let(:fixture) { 'merge_request_comment.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Tester
          commented on
          merge request
          <a href='https://gitlab.com/trickcomments/test/merge_requests/30#note_1244'>trickcomments#30</a>
          <b>Connect to Idobata(Merge request)</b>
        </div>
        <p>
          This MR needs work.
        </p>
      HTML
    end

    describe 'snippet comment event' do
      let(:fixture) { 'snippet_comment.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Tester
          commented on
          snippet
          <a href='https://gitlab.com/trickcomments/test/snippets/53#note_1245'>trickcomments#53</a>
          <b>Connect to Idobata(Snippet)</b>
        </div>
        <p>
          Is this snippet doing what it's supposed to be doing?
        </p>
      HTML
    end

    describe 'commit comment event' do
      let(:fixture) { 'commit_comment.json' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Tester
          commented on
          commit
          <a href='https://gitlab.com/trickcomments/test/commit/cfe32cf61b73a0d5e9f13e774abde7ff789b1660#note_1243'>trickcomments#cfe32cf61b73a0d5e9f13e774abde7ff789b1660</a>
        </div>
        <p>
          This is a commit comment. How does this work?
        </p>
      HTML
    end

    describe 'pipeline event' do
      let(:fixture) { 'pipeline.json' }


      it { expect(subject[:source]).to be_dom_equal <<~HTML }
        <div>
          <span class='label label-danger'>
          failed
          </span>
          &nbsp;
          <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/pipelines/31'>Pipeline #31</a>
          on 
          <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test'>Gitlab Test</a>

          <details>
            <summary>
              Jobs
            </summary>
            <ul>
              <li>
                <span class='col-xs-1 label label-success'>
                success
                </span>
                &nbsp;
                <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/-/jobs/376'>build-image</a>
              </li>
              <li>
                <span class='col-xs-1 label label-success'>
                success
                </span>
                &nbsp;
                <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/-/jobs/377'>test-image</a>
              </li>
              <li>
                <span class='col-xs-1 label label-info'>
                created
                </span>
                &nbsp;
                <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/-/jobs/378'>test</a>
              </li>
              <li>
                <span class='col-xs-1 label label-danger'>
                failed
                </span>
                &nbsp;
                <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/-/jobs/379'>staging</a>
              </li>
              <li>
                <span class='col-xs-1 label label-default'>
                skipped
                </span>
                &nbsp;
                <a href='http://192.168.64.1:3005/gitlab-org/gitlab-test/-/jobs/380'>production</a>
              </li>
            </ul>
          </details>
        </div>
      HTML
    end
  end
end
