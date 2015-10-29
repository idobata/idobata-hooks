describe Idobata::Hook::PivotalTracker, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    describe 'API v3' do
      let(:payload) { fixture_payload("pivotal/v3.xml") }

      before do
        post payload, 'Content-Type' => 'application/xml'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <div>
          ursm added &quot;test&quot;
          <a href='http://www.pivotaltracker.com/story/show/31693177'>
            <span class='story-id'>#31693177</span>
          </a>
        </div>
      HTML
      its([:format]) { should eq(:html) }
    end

    describe 'API v5' do
      let(:payload) { fixture_payload('pivotal/v5.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Ryunosuke SATO added story
          <a href='http://www.pivotaltracker.com/story/show/56193170'>
            <span class='story-id'>#56193170</span>
          </a>
          <img height='14' src='/assets/pivotal_tracker/images/icons/feature.png' width='14'>&nbsp;<b>Upgrade Ember version to 1.6.0</b></p>
        <p>And ember data...</p>
      HTML
      its([:format]) { should eq(:html) }
    end

    describe 'API v5 create comment' do
      let(:payload) { fixture_payload('pivotal/v5+comment_create.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Ryunosuke SATO added comment: story
          <a href='http://www.pivotaltracker.com/story/show/56193124'>
            <span class='story-id'>#56193124</span>
          </a>
          <img height='14' src='/assets/pivotal_tracker/images/icons/feature.png' width='14'>&nbsp;<b>ping</b></p>
        <h1>title</h1>

        <p>hey<br>
        hey<br>
        ho</p>
      HTML
    end

    describe 'API v5 file attachment' do
      let(:payload) { fixture_payload('pivotal/v5+file_attachment.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Ryunosuke SATO added comment with attachments: story
          <a href='https://www.pivotaltracker.com/story/show/70561082'>
            <span class='story-id'>#70561082</span>
          </a>
          <img height='14' src='/assets/pivotal_tracker/images/icons/chore.png' width='14'>&nbsp;<b>chore!</b></p>
        <p>This is file!</p>
        <ul class='thumbnails pivotal-attachments'>
          <li class='thumbnail'>
            <a href='https://www.pivotaltracker.com/file_attachments/31360000/download?inline=true'>
              <img src='https://s3.amazonaws.com/prod.tracker2/resource/31360000/screenshot_thumb.png?AWSAccessKeyId=AKIAIKWOAN6H4H2QMJ6Q&amp;Expires=1400489423&amp;Signature=GDdasG9NBmAQXtE3X46agM0EnJY%3D' title='screenshot.png'>
            </a>
          </li>
          <li class='thumbnail'>
            <a href='https://www.pivotaltracker.com/file_attachments/31360000/download?inline=true'>
              <div class='extname'>xls</div>
              <div class='filename'>(attendance_sheet.xls)</div>
            </a>
          </li>
        </ul>
      HTML
    end

    describe 'API v5 epic' do
      let(:payload) { fixture_payload('pivotal/v5+epic.json') }

      before do
        post payload, 'Content-Type' => 'application/json'
      end

      its([:source]) { should eq(<<-HTML.strip_heredoc) }
        <p>
          Ryunosuke SATO added epic
          <a href='https://www.pivotaltracker.com/epic/show/1263316'>
            <span class='story-id'>#1263316</span>
          </a><b>EPIC!!!</b></p>
      HTML
    end
  end
end
