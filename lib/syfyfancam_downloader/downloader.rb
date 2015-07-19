require 'open-uri'

module SyfyfancamDownloader
  class Downloader
    attr_reader :parser, :output

    def initialize(parser:, output: $stdout)
      @parser = parser
      @output = output
    end

    def download_files
      Dir.mkdir parser.personal_hash unless already_created
      parser.build_urls.each do |url|
        download_file(url)
      end
    end

    private

    def download_file(url)
      store_path = "#{parser.personal_hash}/#{url.split('/').last}"
      output << "Downloading #{url} to #{store_path}\n"
      File.open(store_path, 'wb') do |file|
        file << open(url).read
      end
    end

    def already_created
      File.exist?(parser.personal_hash) && File.directory?(parser.personal_hash)
    end
  end
end
