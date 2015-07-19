RSpec.describe SyfyfancamDownloader::URLParser do
  context 'valid URL' do
    let(:url) { 'http://www.syfyfancam.com/videos/ojt1nd5bnbog/' }
    let(:html) do
      <<-EOS
      <html><head><title></title>
      <meta property="og:image" content="https://g.gl/b4tYn1RX2wMQ/023.jpg" />
      </head><body></body></html>
      EOS
    end

    subject(:parser) { described_class.new(url) }

    before do
      allow(parser).to receive(:open).and_return(html)
    end

    describe '#personal_hash' do
      it 'returns the hash' do
        expect(parser.personal_hash).to eq('b4tYn1RX2wMQ')
        expect(parser).to have_received(:open).once
      end
    end

    describe '#base_url' do
      it 'returns the base url' do
        expect(parser.base_url).to eq('https://g.gl/b4tYn1RX2wMQ/')
        expect(parser).to have_received(:open).once
      end
    end

    describe '#build_urls' do
      it 'returns an array of 100 URLs' do
        allow(parser).to receive(:base_url).and_return('http://a.com/')

        urls = parser.build_urls

        expect(urls.size).to eq(100)
        expect(urls[0]).to eq('http://a.com/001.jpg')
        expect(urls[1]).to eq('http://a.com/002.jpg')
        expect(urls[35]).to eq('http://a.com/036.jpg')
        expect(urls[99]).to eq('http://a.com/100.jpg')
      end
    end
  end

  context 'Not valid URL' do
    let(:url) { 'http://www.nintendo.co.jp/' }

    describe '#initialize' do
      it 'fails to create an instance' do
        expect { described_class.new(url) }.to raise_error(RuntimeError)
      end

      it 'outputs a help message' do
        expect { described_class.new(url) }
          .to raise_error(SyfyfancamDownloader::HELP_MSG)
      end
    end
  end
end
