require 'syfyfancam'

module SyfyfancamDownloader
  class Downloader
    attr_reader :parser, :output

    def initialize(url:, output: $stdout)
      @parser = Syfyfancam::URL.new(url)
      @output = output
    end

    def download_files
      Dir.mkdir default_directory unless already_created
      parser.images.each do |url|
        download_file(URI.parse(url))
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
