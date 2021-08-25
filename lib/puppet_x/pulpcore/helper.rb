require 'puppet'
require 'pulp_file_client'

module PuppetX
  module Pulpcore
    module Helper
      def self.get_pulp_href(name)
        apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
        PulpFileClient.configure do |config|
          config.scheme     = apiconfig['scheme']
          config.host       = apiconfig['host']
          config.ssl_verify = apiconfig['ssl_verify']
          config.username   = apiconfig['username']
          config.password   = apiconfig['password']
        end

        api_instance = PulpFileClient::RepositoriesFileApi.new

        begin
          response = api_instance.list({limit: 1, name: name}).to_hash
          if response[:count] != 1
            context.err("Found not exactly 1 repository with #{name}, found #{response[:count]}.")
          end
          pulp_href = response[:results][0][:pulp_href]
        rescue PulpFileClient::ApiError => e
          context.err("Exception when calling FileFileClient->list[#{name}]: #{e}")
        end

        pulp_href
      end

      def self.hash_to_object(hash)
        PulpFileClient::FileFileRepository.new(
          hash.tap { |value| value.delete(:ensure) }
        )
      end
    end
  end
end
