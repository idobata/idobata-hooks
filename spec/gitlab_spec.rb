require 'spec_helper'

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

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span>John Smith</span>
          pushed to
          <a href='http://example.com/diaspora/tree/master'>master</a>
          at
          <a href='http://example.com/diaspora'>diaspora</a>
          (<a href='http://example.com/diaspora/compare/95790bf891e76fee5e1747ab589903a6a1f80f22...da1560886d4f094c3e6c9ef40349f7d38b5d27d7'>compare</a>)
        </p>
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

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span>tricknotes</span>
          created tag
          <a href='http://example.com/tricknotes/test/commits/hi'>hi</a>
          at
          <a href='http://example.com/tricknotes/test'>tricknotes/test</a>
        </p>
      HTML
    end

    describe 'issue event' do
      let(:fixture) { 'issue.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Ryunosuke SATO
          closed
          issue
          <a href='https://gitlab.com/tricknotes/test/issues/1'>tricknotes#1</a>
          <b>This is a new issue.</b>
        </p>

      HTML
    end

    describe 'old issue event (Gitlab 7.0.0)' do
      let(:fixture) { 'issue-7.0.0.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          The issue was reopened:
          #2
          <b>hoihoi</b>
        </p>

      HTML
    end

    describe 'merge request event' do
      let(:fixture) { 'merge_request.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://secure.gravatar.com/avatar/5c22169c1f836709eea59cebfcd6356a?s=40&amp;d=identicon" width="16" height="16" alt="" /></span>
          Ryunosuke SATO
          opened
          merge request
          <a href='https://gitlab.com/tricknotes/test/merge_requests/1'>tricknotes/test#1</a>
          <b>Ping</b>
        </p>
      HTML
    end

    describe 'old merge request event (Gitlab 7.0.0)' do
      let(:fixture) { 'merge_request-7.0.0.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
       <p>
         The merge request was closed:
         <b>Ping!</b>
       </p>
      HTML
    end

    describe 'project create event' do
      let(:fixture) { 'project_create.json' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        The new project <b>alice/hoi</b> is created.
      HTML
    end
  end
end
