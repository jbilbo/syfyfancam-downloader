require 'nokogiri'
require 'open-uri'

module SyfyfancamDownloader
  class URLParser
    attr_reader :url

    def initialize(url)
      @url = url
      fail SyfyfancamDownloader::HELP_MSG unless personal_hash?
    end

    def base_url
      @doc ||= Nokogiri::HTML(open(url))
      @doc.at('meta[property="og:image"]')['content'][0..-8]
    end

    def personal_hash
      base_url.split('/').last
    end

    def build_url(num)
      number = format('%03d', num)

      "#{base_url}#{number}.jpg"
    end

    private

    def personal_hash?
      url.split('/').last.size == 12
    end
  end
end
