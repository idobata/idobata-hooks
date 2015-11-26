describe Idobata::Hook::Backlog, type: :hook do
  let(:payload) { fixture_payload("backlog/#{payload_type}.json") }

  describe '#process_payload' do
    subject { hook.process_payload }

    context 'on type error' do
      let(:payload_type) { 'type_error' }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      subject { ->{ hook.process_payload } }

      it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
    end

    context 'on issue create without space_id' do
      let(:payload_type) { 'issue_create' }

      before do
        post payload, {'Content-Type' => 'application/json'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          test issue
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
          <a href="https://test.backlog.jp/view/TEST-100">test issue</a>
          created by ozamasa.
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
          <a href="https://test.backlog.jp/view/TEST-100#comment-200">test issue</a>
          updated by ozamasa.
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
          <a href="https://test.backlog.jp/view/TEST-100#comment-200">test issue</a>
          commented by ozamasa.
        </p>
        <p>test comment</p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue delete' do
      let(:payload_type) { 'issue_delete' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>TEST-100 issue deleted by ozamasa.</p>
      HTML

      its([:format]) { should eq(:html) }
    end

    context 'on issue multiple update' do
      let(:payload_type) { 'issue_multiple_update' }

      before do
        post payload, {'Content-Type' => 'application/json'}, {space_id: 'test'}
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>multiple issues updated by ozamasa.</p>
        <ul>
          <li><a href="https://test.backlog.jp/view/TEST-100">test issue1</a></li>
          <li><a href="https://test.backlog.jp/view/TEST-101">test issue2</a></li>
        </ul>
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
          <a href="https://test.backlog.jp/view/TEST-100#comment-200">test issue</a>
          noticed by ozamasa.
        </p>
        <p>test comment</p>
      HTML

      its([:format]) { should eq(:html) }
    end
  end
end
