require 'nokogiri'
require 'uri'
require 'net/http'

module SyfyfancamDownloader
  class URLParser
    attr_reader :uri

    def initialize(url)
      @uri = URI.parse(url)
      fail SyfyfancamDownloader::HELP_MSG unless personal_hash?
    rescue URI::InvalidURIError => e
      raise e, SyfyfancamDownloader::HELP_MSG
    end

    def base_url
      @base_url ||= Nokogiri::HTML(Net::HTTP.get(uri)).at('meta[property="og:image"]')['content'][0..-8]
    end

    def personal_hash
      uri.to_s.split('/').last
    end

    def build_uris
      build_urls.map { |url| URI.parse(url) }
    end

    def build_urls
      (1..100).map { |i| "#{base_url}#{format('%03d', i)}.jpg" }
    end

    private

    def personal_hash?
      personal_hash && personal_hash.size == 12
    end
  end
end
