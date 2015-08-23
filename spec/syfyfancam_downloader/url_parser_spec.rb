RSpec.describe SyfyfancamDownloader::URLParser do
  context 'valid URL' do
    let(:url) { 'http://www.syfyfancam.com/videos/ojt1nd5bnbog/' }
    let(:html) do
      <<-EOS
      <html><head><title></title>
      <meta property="og:image" content="http://d1fmy74dfqc2hp.cf.net/resources/footage/vE/oJt1Nd5BnboG/024.jpg" />
      </head><body></body></html>
      EOS
    end

    subject(:parser) { described_class.new(url) }

    before do
      allow(Net::HTTP).to receive(:get).with(parser.uri).and_return(html)
    end

    describe '#personal_hash' do
      it 'returns the hash' do
        expect(parser.personal_hash).to eq('ojt1nd5bnbog')
        expect(Net::HTTP).to_not have_received(:get)
      end
    end

    describe '#base_url' do
      it 'returns the base url' do
        expect(parser.base_url).to eq('http://d1fmy74dfqc2hp.cf.net/resources/footage/vE/oJt1Nd5BnboG/')
        expect(Net::HTTP).to have_received(:get).once
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

  context 'Wrong URL' do
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

    context 'Not valid URL' do
      let(:url) { '|cat /etc/passwd' }

      describe '#initialize' do
        it 'fails to create an instance' do
          expect { described_class.new(url) }.to raise_error(URI::InvalidURIError)
        end

        it 'outputs a help message' do
          expect { described_class.new(url) }
            .to raise_error(SyfyfancamDownloader::HELP_MSG)
        end
      end
    end
  end
end
