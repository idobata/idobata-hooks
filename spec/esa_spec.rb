describe Idobata::Hook::Esa, type: :hook do
  let(:payload) { fixture_payload("esa/#{event_type}.json") }

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on member_join' do
      let(:event_type) { 'member_join' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
       <div>
         <span><img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" /></span>
         Atsuo Fukaya (fukayatsu)
         joined
         <a href='https://esa.esa.io/team'>esa team</a>
         (\( ⁰⊖⁰)/)
       </div>
      HTML
    end

    context 'on post_create' do
      let(:event_type) { 'post_create' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
      <div>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        created
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        <b>たいとる</b>
      </div>
      <blockquote>Create post.</blockquote>
      <div><p>ほんぶん</p></div>
      HTML
    end

    context 'on post_create with hide_body=true' do
      let(:event_type) { 'post_create' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {hide_body: 'true'}
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
      <div>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        created
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        <b>たいとる</b>
      </div>
      <blockquote>Create post.</blockquote>
      HTML
    end

    context 'on post_update' do
      let(:event_type) { 'post_update' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
      <div>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        updated
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        (<a href='https://example.esa.io/posts/1253/revisions/3'>diff</a>)
        <b>たいとる</b>
      </div>
      <blockquote>Update post.</blockquote>
      HTML
    end

    context 'on post_archive' do
      let(:event_type) { 'post_archive' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
      <div>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        archived
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        <b>Archived/たいとる</b>
      </div>
      <blockquote>Archived!</blockquote>
      HTML
    end

    context 'on comment_create' do
      let(:event_type) { 'comment_create' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      it { expect(subject[:source]).to be_dom_equal <<~'HTML' }
      <div>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        commented on
        <a href='https://example.esa.io/posts/1253#comment-6385'>esa#1253</a>
        <b>Archived/たいとる</b>
      </div>
      <p>こめんと</p>
      HTML
    end
  end
end
