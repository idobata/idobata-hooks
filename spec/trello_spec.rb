describe Idobata::Hook::Trello, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    let(:payload) { fixture_payload("trello/#{event_type}.json") }

    describe 'POST hook' do
      before do
        post payload, 'Content-Type' => 'application/json'
      end

      describe 'createCard event' do
        let(:event_type) { 'create_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          created
          <a href='https://trello.com/c/ewbtA4tx'>createCard</a>
          in
          Advanced
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'deleteCard event' do
        let(:event_type) { 'delete_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          deleted card
          #32
          from
          Advanced
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'updateCard event' do
        describe 'archive' do
          let(:event_type) { 'update_card_archive' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            archived
            <a href='https://trello.com/c/ewbtA4tx'>archiveCard</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'unarchive' do
          let(:event_type) { 'update_card_unarchive' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            unarchived
            <a href='https://trello.com/c/ewbtA4tx'>Test</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'move' do
          let(:event_type) { 'update_card_move' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            moved
            <a href='https://trello.com/c/ewbtA4tx'>Test</a>
            to
            Basics
            from
            Advanced
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'move position' do
          let(:event_type) { 'update_card_move_position' }

          subject { ->{ hook.process_payload } }

          it { expect(subject).to raise_error(Idobata::Hook::SkipProcessing) }
        end

        describe 'update description' do
          let(:event_type) { 'update_card_update_description' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            updated description in
            <a href='https://trello.com/c/ewbtA4tx'>Test</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
            <h1>Description.</h1>

            <p><strong>This is a description.</strong></p>

            <hr>

            <p><a href="http://example.com">link</a></p>
          HTML
        end

        describe 'update due' do
          let(:event_type) { 'update_card_update_due' }

          # FIXME: ugly
          let(:datetime) { DateTime.parse('2014-07-31 03:00:00+00:00').to_time.strftime('%Y/%m/%d %H:%M:%S') }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            set due to
            #{datetime}
            for
            <a href='https://trello.com/c/ewbtA4tx'>Test</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'remove due' do
          let(:event_type) { 'update_card_remove_due' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            removed due
            for
            <a href='https://trello.com/c/ewbtA4tx'>Test</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'update name' do
          let(:event_type) { 'update_card_update_name' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            updated name to
            <a href='https://trello.com/c/ewbtA4tx'>update name</a>
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end
      end

      describe 'commentCard event' do
        let(:event_type) { 'comment_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          commented on
          <a href='https://trello.com/c/dDalFBhh'>Test</a>
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          <p>This is a test.</p>
        HTML
      end

      describe 'addMemberToCard event' do
        let(:event_type) { 'add_member_to_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          added
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          to
          <a href='https://trello.com/c/dDalFBhh'>Test</a>
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'removeMemberFormCard event' do
        let(:event_type) { 'remove_member_from_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          removed
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          from
          <a href='https://trello.com/c/dDalFBhh'>Test</a>
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'addLabelFromCard event' do
        let(:event_type) { 'add_label_to_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          added
          green
          label
          to
          <a href='https://trello.com/c/dDalFBhh'>Test</a>
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'removeLabelFromCard event' do
        let(:event_type) { 'remove_label_from_card' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          removed
          green
          label
          from
          <a href='https://trello.com/c/dDalFBhh'>Test</a>
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'createList event' do
        let(:event_type) { 'create_list' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          created
          Test
          on
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'updateList event' do
        describe 'archive' do
          let(:event_type) { 'update_list_archive' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            archived
            Test
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'unarchive' do
          let(:event_type) { 'update_list_unarchive' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            unarchived
            Test
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end

        describe 'update name' do
          let(:event_type) { 'update_list_update_name' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            updated name to
            Another Test
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end
      end

      describe 'moveListFromBoard event' do
        let(:event_type) { 'move_list_to_board' }

        its([:source]) { should == <<-HTML.strip_heredoc }
          <span class='trello-member-initials'>EK</span>
          <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
          moved
          Test
          to
          Test
          from
          <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
        HTML
      end

      describe 'updateBoard event' do
        describe 'add label' do
          let(:event_type) { 'update_board_add_label' }

          its([:source]) { should == <<-HTML.strip_heredoc }
            <span class='trello-member-initials'>EK</span>
            <a href='https://trello.com/eitokatagiri2'>eitokatagiri2</a>
            named
            green
            label
            to
            NewLabelName
            on
            <a href='https://trello.com/b/zlgpqYq6'>Welcome Board</a>
          HTML
        end
      end
    end
  end
end
