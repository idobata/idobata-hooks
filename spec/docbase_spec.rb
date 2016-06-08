describe Idobata::Hook::Docbase, type: :hook do
  let(:payload) { fixture_payload("docbase/#{event_type}.json") }

  describe 'POST hook' do
    subject { hook.process_payload }

    before do
      post payload, 'Content-Type' => 'application/json'
    end

    describe 'post_publish event' do
      let(:event_type) { 'post_publish' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          posted <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'post_update event' do
      let(:event_type) { 'post_update' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          edited <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'post_group_update event' do
      let(:event_type) { 'post_group_update' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          changed viewing permissions of <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'sharing_create event' do
      let(:event_type) { 'sharing_create' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          shared <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'sharing_destroy event' do
      let(:event_type) { 'sharing_destroy' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          unshared <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'comment_create event' do
      let(:event_type) { 'comment_create' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          commented on <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
          <p>コメントテスト</p>
        HTML
    end

    describe 'star_create event' do
      let(:event_type) { 'star_create' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          starred <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'like_create event' do
      let(:event_type) { 'like_create' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          likes <a href='https://idobata.docbase.io/posts/1'>hookの作り方</a>
          at idobata
          </p>
        HTML
    end

    describe 'team_join event' do
      let(:event_type) { 'team_join' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/2'>hukui</a>
          joined Team <a href='https://idobata.docbase.io/groups/1'>idobata</a>
          </p>
        HTML
    end

    describe 'group_join event' do
      let(:event_type) { 'group_join' }

      it { expect(subject[:source]).to be_dom_equal <<~HTML }
          <p>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/1'>eiwakun</a>
          <span><img src="https://secure.gravatar.com/avatar/9922bb39304a94c92e862211c23d60fc.png" width="16" height="16" alt="" /></span>
          <a href='https://idobata.docbase.io/users/2'>hukui</a>
          joined Group <a href='https://idobata.docbase.io/groups/1'>idobata</a>
          </p>
        HTML
    end
  end
end
