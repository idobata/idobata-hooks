require 'spec_helper'

describe Idobata::Hook::QiitaTeam, type: :hook do
  let(:payload) { fixture_payload("qiita_team/#{fixture}") }

  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post payload,
        'Content-Type' => 'application/json',
        'X-Qiita-Event-Model' => qiita_event_model_type
    end

    describe 'item created event' do
      let(:fixture) { 'item_created.json' }
      let(:qiita_event_model_type) { 'item' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/429833774562439168/gEY-Y6IJ_normal.jpeg" width="16" height="16" alt="" /></span>
          hanachin_
          created
          <a href='https://hanachin.qiita.com/hanachin_/items/d7a204610de2097df0c4'>hi</a>
        </p>
        <p><code>hi</code></p>
      HTML
      its([:format]) { should eq(:html) }
    end

    describe 'item updated event' do
      let(:fixture) { 'item_updated.json' }
      let(:qiita_event_model_type) { 'item' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/1542801560/Qiita_normal.png" width="16" height="16" alt="" /></span>
          qiitan
          updated
          <a href='https://hanachin.qiita.com/hanachin_/items/d7a204610de2097df0c4'>hi</a>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'comment created event' do
      let(:fixture) { 'comment_created.json' }
      let(:qiita_event_model_type) { 'comment' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/429833774562439168/gEY-Y6IJ_normal.jpeg" width="16" height="16" alt="" /></span>
          hanachin_
          posted
          <a href='https://hanachin.qiita.com/hanachin_/items/d7a204610de2097df0c4#comment-645d16bf39452455e5d7'>comment</a>
        </p>
        <p><code>hi comment</code></p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'comment created event (complex case)' do
      let(:fixture) { 'comment_created_2.json' }
      let(:qiita_event_model_type) { 'comment' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://secure.gravatar.com/avatar/f966e93db0fbaf3aa07f7df5fa136933?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png" width="16" height="16" alt="" /></span>
          ursm
          posted
          <a href='https://idobata.qiita.com/tricknotes/items/8fb60872a90868fb311b#comment-410b03f7c2b47ee8141e'>comment</a>
        </p>
        <h1>
                
                heading
              </h1><p><img class="emoji" title=":trollface:" alt=":trollface:" src="/images/emoji/trollface.png" height="20" width="20" align="absmiddle"> </p>
      HTML
    end

    describe 'comment updated event' do
      let(:fixture) { 'comment_updated.json' }
      let(:qiita_event_model_type) { 'comment' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/429833774562439168/gEY-Y6IJ_normal.jpeg" width="16" height="16" alt="" /></span>
          hanachin_
          updated
          <a href='https://hanachin.qiita.com/hanachin_/items/d7a204610de2097df0c4#comment-645d16bf39452455e5d7'>comment</a>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'member added event' do
      let(:fixture) { 'member_added.json' }
      let(:qiita_event_model_type) { 'member' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/3188172053/ae5b95121f109b762c565189fc65ff3a_normal.png" width="16" height="16" alt="" /></span>
          <a href='http://qiita.com/tompng'>tompng</a>
          is
          added
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'member removed event' do
      let(:fixture) { 'member_removed.json' }
      let(:qiita_event_model_type) { 'member' }

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <span><img src="https://pbs.twimg.com/profile_images/3188172053/ae5b95121f109b762c565189fc65ff3a_normal.png" width="16" height="16" alt="" /></span>
          <a href='http://qiita.com/tompng'>tompng</a>
          is
          removed
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    describe 'project created event' do
      subject { -> { hook.process_payload } }

      let(:fixture) { 'project_created.json' }
      let(:qiita_event_model_type) { 'project' }

      it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
    end

    describe 'destroy actions' do
      subject { -> { hook.process_payload } }

      describe 'item destroyed event' do
        let(:fixture) { 'item_destroyed.json' }
        let(:qiita_event_model_type) { 'item' }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end

      describe 'comment destroyed event' do
        let(:fixture) { 'comment_destroyed.json' }
        let(:qiita_event_model_type) { 'comment' }

        it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
      end
    end
  end
end
