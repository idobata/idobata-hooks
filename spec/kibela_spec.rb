describe Idobata::Hook::Kibela, type: :hook do
  let(:payload) { fixture_payload("kibela/#{event_type}.json") }

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on blog_create' do
      let(:event_type) { 'blog_create' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <div>
        <i class='fa fa-plus-square-o'></i>
        【blog】
        <span>
          <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
        </span>
        kibe
        created
        <a href='https://docs.kibe.la/@kibe/1'>sample request</a>
      </div>
      <h2>sample request</h2>
      HTML
    end

    context 'on wiki_update' do
      let(:event_type) { 'wiki_update' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <div>
        <i class='fa fa-pencil-square-o'></i>
        【wiki】
        <span>
          <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
        </span>
        kibe
        updated
        <a href='https://docs.kibe.la/wikis/sample_request/1'>sample request</a>
        (
        <a href='https://docs.kibe.la/wikis/1/versions/1'>diff</a>
        )
      </div>
      <h2>sample request</h2>
      HTML
    end

    context 'on comment_delete' do
      let(:event_type) { 'comment_delete' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <div>
        <i class='fa fa-trash'></i>
        【comment】
        <span>
          <img src="https://cdn.kibe.la/media/public/1/kibe.png" width="16" height="16" alt="" />
        </span>
        kibe
        deleted
        <a href='https://docs.kibe.la/@kibe/1#comment_1'></a>
      </div>
      HTML
    end
  end
end
