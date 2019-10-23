# frozen_string_literal: true

RSpec.describe SyfyfancamDownloader::CLI do
  let(:downloader) { double('downloader') }
  let(:parser) { double('parser', personal_hash: 'b') }

  before do
    allow(SyfyfancamDownloader::Downloader).to receive(:new)
      .and_return(downloader)
    allow(downloader).to receive(:download_files)
  end

  describe '#start' do
    context 'without arguments' do
      let(:args) { nil }

      it 'returns an error' do
        expect { described_class.start(args) }
          .to raise_error(RuntimeError, SyfyfancamDownloader::HELP_MSG)
      end
    end

    context 'with arguments' do
      let(:args) { ['http://www.syfyfancam.com/videos/ojt1nd5bnbog/'] }

      it 'calls the downloader with the first argument' do
        described_class.start(args)

        expect(SyfyfancamDownloader::Downloader).to have_received(:new)
          .with(url: 'http://www.syfyfancam.com/videos/ojt1nd5bnbog/').once
        expect(downloader).to have_received(:download_files).once
      end
    end
  end
end
