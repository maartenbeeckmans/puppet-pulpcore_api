require 'pulp_container_client'
require 'pulp_deb_client'
require 'pulp_file_client'
require 'pulp_rpm_client'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::sync_repository') do
  #
  # @summary A function that syncs a repository
  #   This function should be called as a deferred function
  #
  # @example
  #   Deferred(pulpcore::sync_repository($repository_href, 'file'))
  #
  # @param repository_href
  #   The pulp href of the repository to sync
  #
  # @param plugin
  #   Name of the plugin of the pulp resource
  #
  # @return String
  #   Result of the sync action
  #
  # @TODO: Add required parameters to RepositorySyncUrl
  #
  dispatch :sync_repository do
    param 'String[1]', :repository_href
    param 'Enum[container,deb,file,rpm]', :plugin
    return_type 'String'
  end

  def get_pulp_href(repository_href, plugin)
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
      api_instance = PulpContainerClient::RepositoriesRpmApi.new
      begin
        response = api_instance.sync(repository_href, PulpContainerClient::RepositorySyncUrl.new)
      rescue PulpContainerClient::ApiError => e
        context.err("Exception when calling RepositoriesContainerApi->sync: #{e}")
      end
    when 'deb'
      PulpDebClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      api_instance = PulpDebClient::RepositoriesDebApi.new
      begin
        response = api_instance.sync(repository_href, PulpDebClient::RepositorySyncUrl.new)
      rescue PulpDebClient::ApiError => e
        context.err("Exception when calling RepositoriesDebApi->sync: #{e}")
      end
    when 'file'
      PulpFileClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      api_instance = PulpFileClient::RepositoriesFileApi.new
      begin
        response = api_instance.sync(repository_href, PulpFileClient::RepositorySyncUrl.new)
      rescue PulpFileClient::ApiError => e
        context.err("Exception when calling RepositoriesFileApi->sync: #{e}")
      end
    when 'rpm'
      PulpRpmClient.configure do |config|s
        config.scheme     = apiconfig['scheme']
        config.host       = apiconfig['host']
        config.ssl_verify = apiconfig['ssl_verify']
        config.username   = apiconfig['username']
        config.password   = apiconfig['password']
      end
      api_instance = PulpRpmClient::RepositoriesRpmApi.new
      begin
        response = api_instance.sync(repository_href, PulpRpmClient::RpmRepositorySyncURL.new)
      rescue PulpRpmClient::ApiError => e
        context.err("Exception when calling RepositoriesRpmApi->sync: #{e}")
      end
    else
      raise "Plugin #{plugin} not supported"
    end

  end
end
