require 'net/http'

module SyfyfancamDownloader
  class Downloader
    attr_reader :parser, :output

    def initialize(parser:, output: $stdout)
      @parser = parser
      @output = output
    end

    def download_files
      Dir.mkdir parser.personal_hash unless already_created
      parser.build_uris.each do |uri|
        download_file(uri)
      end
    end

    private

    def download_file(uri)
      store_path = "#{parser.personal_hash}/#{uri.to_s.split('/').last}"
      output << "Downloading #{uri} to #{store_path}\n"
      File.open(store_path, 'wb') do |file|
        file << Net::HTTP.get(uri)
      end
    end

    def already_created
      File.exist?(parser.personal_hash) && File.directory?(parser.personal_hash)
    end
  end
end
