describe Idobata::Hook::Kibela, type: :hook do
  let(:payload) { fixture_payload("kibela/#{event_type}.json") }

  describe '#process_payload' do
    subject { hook.process_payload }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    context "page" do
      context 'on blog_create' do
        let(:event_type) { 'blog_create' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe created a blog "
          <a href='https://docs.kibe.la/@kibe/1'>sample request</a>
          ".
        </div>
        <div>
          <h2>sample request</h2>
        </div>
        HTML
      end

      context 'on wiki_update' do
        let(:event_type) { 'wiki_update' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe updated a wiki "
          <a href='https://docs.kibe.la/wikis/sample_request/1'>sample request</a>
          ".
          (
          <a href='https://docs.kibe.la/wikis/1/versions/1'>diff</a>
          )
        </div>
        <div>
          <h2>sample request</h2>
        </div>
        HTML
      end

      context 'on blog_delete' do
        let(:event_type) { 'blog_delete' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe deleted a blog "
          sample request
          ".
        </div>
        HTML
      end
    end
    context "comment" do
      context 'on comment_create' do
        let(:event_type) { 'comment_create' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe commented on "
          <a href='https://docs.kibe.la/@kibe/1#comment_1'>sample request</a>
          ".
        </div>
        <div>
          <h2>sample request</h2>
        </div>
        HTML
      end

      context 'on comment_delete' do
        let(:event_type) { 'comment_delete' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe deleted a comment on "
          <a href='https://docs.kibe.la/@kibe/1#comment_1'>sample request</a>
          ".
        </div>
        HTML
      end
    end

    context 'test' do
      context 'on test_send' do
        let(:event_type) { 'test_send' }

        its([:format]) { should eq(:html) }
        its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
        <div>
          <span>
            <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
          </span>
          kibe set on
          <a href='https://docs.kibe.la/'>docs</a>
        </div>
        HTML
      end
    end
  end
end
