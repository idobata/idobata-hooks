describe Idobata::Hook::Backlog, type: :hook do
  let(:payload) { fixture_payload("backlog/#{payload_type}.json") }

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on issue create without space_id' do
      let(:payload_type) { 'issue_create' }

      before do
        post payload, {'Content-Type' => 'application/json'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          created by ozamasa.
          <p>test description</p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue create' do
      let(:payload_type) { 'issue_create' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          created by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100'>https://test.backlog.jp/view/TEST-100</a>
          </p>
          <p>test description</p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue update' do
      let(:payload_type) { 'issue_update' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          updated by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100#comment-200'>https://test.backlog.jp/view/TEST-100#comment-200</a>
          </p>
          <p></p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue comment' do
      let(:payload_type) { 'issue_comment' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          commented by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100#comment-200'>https://test.backlog.jp/view/TEST-100#comment-200</a>
          </p>
          <p>test comment</p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue comment' do
      let(:payload_type) { 'issue_comment' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          commented by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100#comment-200'>https://test.backlog.jp/view/TEST-100#comment-200</a>
          </p>
          <p>test comment</p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue delete' do
      let(:payload_type) { 'issue_delete' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b></b>
          issue deleted by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100'>https://test.backlog.jp/view/TEST-100</a>
          </p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue multipul update' do
      let(:payload_type) { 'issue_multipul_update' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b></b>
          multiple issues updated by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100'>https://test.backlog.jp/view/TEST-100</a>
          </p>
          <p>
            <a href='https://test.backlog.jp/view/TEST-101'>https://test.backlog.jp/view/TEST-101</a>
          </p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue notice' do
      let(:payload_type) { 'issue_notice' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          <b>test issue</b>
          noticed by ozamasa.
          <p>
            <a href='https://test.backlog.jp/view/TEST-100#comment-200'>https://test.backlog.jp/view/TEST-100#comment-200</a>
          </p>
          <p>test comment</p>
        </p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
