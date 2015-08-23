require 'net/http'

module SyfyfancamDownloader
  class Downloader
    attr_reader :parser, :output

    def initialize(parser:, output: $stdout)
      @parser = parser
      @output = output
    end

    def download_files
      Dir.mkdir default_directory unless already_created
      parser.build_uris.each do |uri|
        download_file(uri)
      end
    end

    private

    def download_file(uri)
      number = uri.to_s.split('/').last
      store_path = "#{default_directory}/#{number}"
      output << "Downloading #{uri} to #{store_path}\n"
      File.open(store_path, 'wb') do |file|
        file << Net::HTTP.get(uri)
      end
    end

    def default_directory
      parser.personal_hash
    end

    def already_created
      File.exist?(default_directory) && File.directory?(default_directory)
    end
  end
end
