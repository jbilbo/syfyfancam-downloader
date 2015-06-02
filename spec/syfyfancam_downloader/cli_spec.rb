RSpec.describe SyfyfancamDownloader::CLI do
  let(:downloader) { double('downloader') }
  let(:parser) { double('parser', base_url: 'a', personal_hash: 'b') }

  before do
    allow(SyfyfancamDownloader::Downloader).to receive(:new)
      .and_return(downloader)
    allow(downloader).to receive(:download_files)

    allow(SyfyfancamDownloader::URLParser).to receive(:new).and_return(parser)
  end

  describe '#start' do
    context 'without arguments' do
      let(:args) { nil }

      it 'returns an error' do
        expect { described_class.start(args) }.to raise_error(RuntimeError)
      end

      it 'shows a help message' do
        expect { described_class.start(args) }
          .to raise_error(SyfyfancamDownloader::HELP_MSG)
      end
    end

    context 'with arguments' do
      let(:args) { ['http://www.syfyfancam.com/videos/ojt1nd5bnbog/'] }

      it 'calls the parser with the first argument' do
        described_class.start(args)

        expect(SyfyfancamDownloader::URLParser).to have_received(:new)
          .with('http://www.syfyfancam.com/videos/ojt1nd5bnbog/').once
      end

      it 'calls the downloader' do
        described_class.start(args)

        expect(SyfyfancamDownloader::Downloader).to have_received(:new)
          .with(parser: parser).once
        expect(downloader).to have_received(:download_files).once
      end
    end
  end
end
