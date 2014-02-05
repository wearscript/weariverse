require 'json'
require 'faraday'
require 'pry'
require 'fileutils'
module Collector
  class Gist
    def self.do id
      gist = JSON.parse connection.get(id).body
      unless /\[wearscript\] (.*)/.match gist['description']
        raise "gist[#{id}]: Does not have necessary [wearscript] prefix in description"
      end
      user = gist['user']

      manifest = JSON.parse gist['files']['manifest.json']['content']
      manifest['description'] = gist['description'][13..-1]
      manifest['id'] = id
      manifest['source_uri'] = gist['html_url']
      manifest['authors'] = [
        {
          github: user['login'],
          url: user['html_url'],
          avatar_url: user['avatar_url'],
        }
      ]

      FileUtils.cd 'scripts' do
        FileUtils.rm_rf id
        FileUtils.mkdir_p id
        FileUtils.cd id do
          File.write "manifest.json", JSON.pretty_generate(manifest)
          gist['files'].each_entry do |name, data|
            next if name == 'manifest.json'
            File.write name, data['content']
          end
        end
      end
    end

    def self.connection
      return @connection if @connection
      @connection = Faraday.new(url: "https://api.github.com/gists/") do |faraday|
        faraday.request :url_encoded
        #faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
