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
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
       <p>
         <span><img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" /></span>
         Atsuo Fukaya (fukayatsu)
         joined
         <a href='https://esa.esa.io/team'>esa team</a>
         (\( ⁰⊖⁰)/)
       </p>
      HTML
    end

    context 'on post_create' do
      let(:event_type) { 'post_create' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <p>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        created
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        <b>たいとる</b>
      </p>
      <blockquote>Create post.</blockquote>
      <br />
      <p>ほんぶん</p>
      HTML
    end

    context 'on post_update' do
      let(:event_type) { 'post_update' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <p>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        updated
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        (<a href='https://example.esa.io/posts/1253/revisions/3'>diff</a>)
        <b>たいとる</b>
      </p>
      <blockquote>Update post.</blockquote>
      <br />
      <p>ほんぶん</p>
      HTML
    end

    context 'on post_archive' do
      let(:event_type) { 'post_archive' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <p>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        archived
        <a href='https://example.esa.io/posts/1253'>esa#1253</a>
        <b>Archived/たいとる</b>
      </p>
      <blockquote>Archived!</blockquote>
      HTML
    end

    context 'on comment_create' do
      let(:event_type) { 'comment_create' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:format]) { should eq(:html) }
      its([:source]) { should eq(<<-'HTML'.strip_heredoc) }
      <p>
        <span>
          <img src="http://img.esa.io/uploads/production/users/1/icon/thumb_s_402685a258cf2a33c1d6c13a89adec92.png" width="16" height="16" alt="" />
        </span>
        fukayatsu
        commented on
        <a href='https://example.esa.io/posts/1253#comment-6385'>esa#1253</a>
        <b>Archived/たいとる</b>
      </p>
      <p>こめんと</p>
      HTML
    end
  end
end
