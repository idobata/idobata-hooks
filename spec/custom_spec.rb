describe Idobata::Hook::Custom, type: :hook do
  describe '#process_payload' do
    subject { hook.process_payload }

    let(:source) { 'hi' }
    let(:image)  { Rack::Multipart::UploadedFile.new(Idobata::Hook.root.join('../spec/fixtures/images/idobata.png').to_s, 'image/png', true) }

    context 'Without format' do
      let(:params) { {source: source}.to_query }

      before do
        post params, 'Content-Type' => 'application/x-www-form-urlencoded'
      end

      its([:source]) { should eq(source) }
      its([:format]) { should eq(:plain) }
    end

    context 'With html format' do
      let(:params) { {source: source, format: :html}.to_query }

      before do
        post params, 'Content-Type' => 'application/x-www-form-urlencoded'
      end

      its([:source]) { should eq(source) }
      its([:format]) { should eq('html') }
    end

    context 'With an image' do
      let(:params) { {source: source, image: image} }

      before do
        post Rack::Multipart.build_multipart(params), 'Content-Type' => "multipart/form-data; boundary=#{Rack::Multipart::MULTIPART_BOUNDARY}"
      end

      its([:source]) { should eq(source) }
      its([:format]) { should eq(:plain) }

      it {
        filenames = subject[:images].map {|image| image['filename'] }
        expect(filenames).to eq([image.original_filename])
      }
    end

    context 'With two image' do
      let(:params) { {source: source, image: [image, image]} }

      before do
        pending 'ArgumentError: invalid byte sequence in UTF-8'

        post Rack::Multipart.build_multipart(params), 'Content-Type' => "multipart/form-data; boundary=#{Rack::Multipart::MULTIPART_BOUNDARY}"
      end

      its([:source]) { should eq(source) }
      its([:format]) { should eq(:plain) }

      it {
        filenames = subject[:images].map {|image| image['filename'] }
        expect(filenames).to eq([image.original_filename] * 2)
      }
    end

    context 'urlencoded data without Content-Type' do
      let(:params) { {source: source}.to_query }

      before do
        post params
      end

      its([:source]) { should eq(source) }
      its([:format]) { should eq(:plain) }
    end
  end
end
