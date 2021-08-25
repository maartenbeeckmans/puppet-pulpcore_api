require 'puppet'
require 'pulp_file_client'
require 'yaml'
require 'puppet'

module PuppetX
  module Pulpcore
    module Config
      def self.get_api_instance
        apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
        PulpFileClient.configure do |config|
          config.scheme     = apiconfig['scheme']
          config.host       = apiconfig['host']
          config.ssl_verify = apiconfig['ssl_verify']
          config.username   = apiconfig['username']
          config.password   = apiconfig['password']
        end

        PulpFileClient::RepositoriesFileApi.new
      end
    end
  end
end
