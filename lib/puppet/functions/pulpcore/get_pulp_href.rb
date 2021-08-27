require 'pulp_container_client'
require 'pulp_deb_client'
require 'pulp_file_client'
require 'pulp_rpm_client'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::get_pulp_href') do
  #
  # @summary A function that gets the pulp href of a pulp object
  #   This function should be called as a deferred function
  #
  # @example
  #   Deferred(pulpcore::get_pulp_href('repo_name', 'file', 'repository'))
  #
  # @param name
  #   Name of the pulp object the pulp_href should be retrieved
  #
  # @param plugin
  #   Name of the plugin of the pulp resource
  #
  # @param resource_type
  #   Name of the resource type
  #
  # @return String
  #   Pulp href of the requested pulp object
  #
  dispatch :get_pulp_href do
    param 'String[1]', :name
    param 'Enum[container,deb,file,rpm]', :plugin
    param 'Enum[remote,repository,distribution,publication]', :resource_type
    return_type 'String'
  end

  def get_pulp_href(resource_name, plugin, resource_type)
    apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))

    case plugin
    when 'container'
      PulpContainerClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      case resource_type
      when 'remote'
        api_instance = PulpContainerClient::RemotesContainerApi.new
      when 'repository'
        api_instance = PulpContainerClient::RepositoriesContainerApi.new
      when 'distribution'
        api_instance = PulpContainerClient::DistributionsContainerApi.new
      else
        raise "Resource type #{resource_type} not supported for plugin #{plugin}"
      end
      begin
        response = api_instance.list({limit: 1, name: name}).to_hash
        if response[:count] != 1
          raise "Found not exactly 1 object with #{name}, found #{response[:count]}."
        end
        pulp_href = response[:results][0][:pulp_href]
      rescue PulpContainerClient::ApiError => e
        raise "Exception when calling PulpContainerClient->list: #{e}"
      end
    when 'deb'
      PulpDebClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      case resource_type
      when 'remote'
        api_instance = PulpDebClient::RemotesAptApi.new
      when 'repository'
        api_instance = PulpDebClient::RepositoriesAptApi.new
      when 'distribution'
        api_instance = PulpDebClient::DistributionsAptApi.new
      when 'publication'
        api_instance = PulpDebClient::PublicationsAptApi.new
      else
        raise "Resource type #{resource_type} not supported for plugin #{plugin}"
      end
      begin
        response = api_instance.list({limit: 1, name: name}).to_hash
        if response[:count] != 1
          raise "Found not exactly 1 object with #{name}, found #{response[:count]}."
        end
        pulp_href = response[:results][0][:pulp_href]
      rescue PulpDebClient::ApiError => e
        raise "Exception when calling PulpDebClient->list: #{e}"
      end
    when 'file'
      PulpFileClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      case resource_type
      when 'remote'
        api_instance = PulpFileClient::RemotesFileApi.new
      when 'repository'
        api_instance = PulpFileClient::RepositoriesFileApi.new
      when 'distribution'
        api_instance = PulpFileClient::DistributionsFileApi.new
      when 'publication'
        api_instance = PulpFileClient::PublicationsFileApi.new
      else
        raise "Resource type #{resource_type} not supported for plugin #{plugin}"
      end
      begin
        response = api_instance.list({limit: 1, name: name}).to_hash
        if response[:count] != 1
          raise "Found not exactly 1 object with #{name}, found #{response[:count]}."
        end
        pulp_href = response[:results][0][:pulp_href]
      rescue PulpFileClient::ApiError => e
        raise "Exception when calling PulpFileClient->list: #{e}"
      end
    when 'rpm'
      PulpRpmClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      case resource_type
      when 'remote'
        api_instance = PulpRpmClient::RemotesFileApi.new
      when 'repository'
        api_instance = PulpRpmClient::RepositoriesFileApi.new
      when 'distribution'
        api_instance = PulpRpmClient::DistributionsFileApi.new
      when 'publication'
        api_instance = PulpRpmClient::PublicationsFileApi.new
      else
        raise "Resource type #{resource_type} not supported for plugin #{plugin}"
      end
      begin
        response = api_instance.list({limit: 1, name: name}).to_hash
        if response[:count] != 1
          raise "Found not exactly 1 object with #{name}, found #{response[:count]}."
        end
        pulp_href = response[:results][0][:pulp_href]
      rescue PulpRpmClient::ApiError => e
        raise "Exception when calling PulpRpmClient->list: #{e}"
      end
    else
      raise "Plugin #{plugin} not supported"
    end

    pulp_href
  end
end
