RSpec.describe SyfyfancamDownloader::Downloader do
  describe '#download_files' do
    let(:url) { 'http://a.com/pic.png' }
    let(:urls) do
      urls = []
      100.times { urls << url }
      urls
    end
    let(:parser) do
      double('parser', personal_hash: 'a', images: urls)
    end
    let(:output) { StringIO.new }

    subject(:downloader) { described_class.new(url: url, output: output) }

    before do
      allow(Dir).to receive(:mkdir)
      allow(File).to receive(:open)

      allow(Syfyfancam::URL).to receive(:new).and_return(parser)
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
