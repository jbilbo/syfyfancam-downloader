# frozen_string_literal: true

module SyfyfancamDownloader
  class CLI
    def self.start(args)
      raise SyfyfancamDownloader::HELP_MSG if args.nil? || args[0].nil?

      SyfyfancamDownloader::Downloader.new(url: args[0])
                                      .download_files
    end
  end
end
