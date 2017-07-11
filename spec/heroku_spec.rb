describe Idobata::Hook::Heroku, type: :hook do
  let(:params) {
    {
      head:      '2907ff8',
      app:       'idobata',
      git_log:   '  * Keita Urashima: style',
      url:       'http://idobata.herokuapp.com',
      prev_head: '13290d2',
      user:      'ursm@ursm.jp',
      head_long: '2907ff8b22f9a56e5c6ea399dc9d62d6bdf9d380',
    }
  }

  before do
    post params.to_json, 'Content-Type' => 'application/json'
  end

  describe '#process_payload' do
    subject { hook.process_payload }
    it { expect(subject[:source]).to be_dom_equal <<~HTML }
      <p>
        ursm@ursm.jp deployed a new version of
        <a href='http://idobata.herokuapp.com'>idobata</a>
        (<tt>2907ff8</tt>)
      </p>
    HTML

    its([:format]) { should eq(:html) }
  end
end
