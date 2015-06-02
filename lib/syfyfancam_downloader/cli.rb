module SyfyfancamDownloader
  class CLI
    def self.start(args)
      fail SyfyfancamDownloader::HELP_MSG if args.nil? || args[0].nil?
      parser = SyfyfancamDownloader::URLParser.new(args[0])
      SyfyfancamDownloader::Downloader.new(parser: parser)
        .download_files
    end
  end
end
