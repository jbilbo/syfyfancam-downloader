RSpec.describe SyfyfancamDownloader::Downloader do
  describe '#download_files' do
    let(:urls) do
      urls = []
      100.times { urls << 'http://a.com/pic.png' }
      urls
    end
    let(:parser) do
      double('parser', personal_hash: 'a', build_urls: urls, base_url: 'http://a.com/')
    end
    let(:output) { StringIO.new }

    subject(:downloader) { described_class.new(parser: parser, output: output) }

    before do
      allow(Dir).to receive(:mkdir)
      allow(File).to receive(:open)
    end

    it 'creates a directory to download the files' do
      downloader.download_files

      expect(Dir).to have_received(:mkdir).once
      expect(File).to have_received(:open).exactly(100).times
    end

    it 'outputs a line for every download' do
      downloader.download_files

      io = begin
        output.rewind
        output.read
      end
      expect(io.scan(/\n/).size).to eq(100)
    end
  end
end
