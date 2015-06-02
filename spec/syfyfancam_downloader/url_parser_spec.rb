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

    describe '#build_url' do
      it 'returns always a three digit number' do
        allow(parser).to receive(:base_url).and_return('http://x.com/')

        expect(parser.build_url(0)).to eq('http://x.com/000.jpg')
        expect(parser.build_url(1)).to eq('http://x.com/001.jpg')
        expect(parser.build_url(35)).to eq('http://x.com/035.jpg')
        expect(parser.build_url(100)).to eq('http://x.com/100.jpg')
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
