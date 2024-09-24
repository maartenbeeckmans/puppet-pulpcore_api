# frozen_string_literal: true

require 'openssl'
require 'puppet'
require 'puppet_x/pulpcore_api/config'
begin
  require 'pulpcore_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulpcore_client gem was not found")
end
begin
  require 'pulp_container_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_container_client gem was not found")
end
begin
  require 'pulp_deb_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_deb_client gem was not found")
end
begin
  require 'pulp_file_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_file_client gem was not found")
end
begin
  require 'pulp_rpm_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_rpm_client gem was not found")
end

module PuppetX::PulpcoreApi # rubocop:disable Style/ClassAndModuleChildren
  class HelperFunctions # rubocop:disable Style/Documentation
    def self.set_client_config(clientconfig, apiconfig)
      clientconfig.scheme          = apiconfig[:scheme]
      clientconfig.host            = apiconfig[:host]
      clientconfig.ssl_verify      = apiconfig[:ssl_verify]
      unless apiconfig[:ssl_ca_file].nil? || apiconfig[:ssl_ca_file].empty?
        clientconfig.ssl_ca_file = apiconfig[:ssl_ca_file]
      end
      unless apiconfig[:ssl_client_cert].nil? || apiconfig[:ssl_client_cert].empty?
        clientconfig.ssl_client_cert = OpenSSL::X509::Certificate.new(File.read(apiconfig[:ssl_client_cert]))
      end
      unless apiconfig[:ssl_client_key].nil? || apiconfig[:ssl_client_key].empty?
        clientconfig.ssl_client_key = OpenSSL::PKey::RSA.new(File.read(apiconfig[:ssl_client_key]))
      end
      clientconfig.username        = apiconfig[:username]
      clientconfig.password        = apiconfig[:password]
    end

    def self.get_api_instance(plugin, object)
      apiconfig = PuppetX::PulpcoreApi::Config.configure

      case plugin
      when 'container'
        PulpContainerClient.configure do |config|
          set_client_config(config, apiconfig)
        end

        case object
        when 'content_guard'
          PulpcoreClient.configure do |config|
            set_client_config(config, apiconfig)
          end
          api_instance = PulpcoreClient::ContentguardsApi.new
        when 'distribution'
          api_instance = PulpContainerClient::DistributionsContainerApi.new
        when 'remote'
          api_instance = PulpContainerClient::RemotesContainerApi.new
        when 'repository'
          api_instance = PulpContainerClient::RepositoriesContainerApi.new
        else
          raise Puppet::ParseError, "Object #{object} not supported for plugin #{plugin}"
        end
      when 'deb'
        PulpDebClient.configure do |config|
          set_client_config(config, apiconfig)
        end

        case object
        when 'content_guard'
          PulpcoreClient.configure do |config|
            set_client_config(config, apiconfig)
          end
          api_instance = PulpcoreClient::ContentguardsApi.new
        when 'distribution'
          api_instance = PulpDebClient::DistributionsAptApi.new
        when 'remote'
          api_instance = PulpDebClient::RemotesAptApi.new
        when 'repository'
          api_instance = PulpDebClient::RepositoriesAptApi.new
        when 'publication'
          api_instance = PulpDebClient::PublicationsAptApi.new
        else
          raise Puppet::ParseError, "Object #{object} not supported for plugin #{plugin}"
        end
      when 'file'
        PulpFileClient.configure do |config|
          set_client_config(config, apiconfig)
        end

        case object
        when 'content_guard'
          PulpcoreClient.configure do |config|
            set_client_config(config, apiconfig)
          end
          api_instance = PulpcoreClient::ContentguardsApi.new
        when 'distribution'
          api_instance = PulpFileClient::DistributionsFileApi.new
        when 'remote'
          api_instance = PulpFileClient::RemotesFileApi.new
        when 'repository'
          api_instance = PulpFileClient::RepositoriesFileApi.new
        when 'publication'
          api_instance = PulpFileClient::PublicationsFileApi.new
        else
          raise Puppet::ParseError, "Object #{object} not supported for plugin #{plugin}"
        end
      when 'rpm'
        PulpRpmClient.configure do |config|
          set_client_config(config, apiconfig)
        end

        case object
        when 'content_guard'
          PulpcoreClient.configure do |config|
            set_client_config(config, apiconfig)
          end
          api_instance = PulpcoreClient::ContentguardsApi.new
        when 'distribution'
          api_instance = PulpRpmClient::DistributionsRpmApi.new
        when 'remote'
          api_instance = PulpRpmClient::RemotesRpmApi.new
        when 'repository'
          api_instance = PulpRpmClient::RepositoriesRpmApi.new
        when 'publication'
          api_instance = PulpRpmClient::PublicationsRpmApi.new
        else
          raise Puppet::ParseError, "Object #{object} not supported for plugin #{plugin}"
        end
      else
        raise Puppet::ParseError, "Plugin #{plugin} is not supported"
      end

      api_instance
    end

    def self.get_pulp_href(name, plugin, object)
      api_instance = get_api_instance(plugin, object)

      # Content guards is currently not supported
      # should be fixed later
      if object == 'content_guard'
        return nil
      end

      begin
        response = api_instance.list({ limit: 1, name: name }).to_hash
        return nil if response[:count] == 0
      rescue PulpRpmClient::ApiError => e
        raise Puppet::ParseError, "Exception when calling #{api_instance}->list: #{e}"
      end
      response[:results][0][:pulp_href]
    end

    def self.get_namevar(pulp_href, plugin, object)
      api_instance = get_api_instance(plugin, object)

      # Content guards is currently not supported
      # should be fixed later
      if object == 'content_guard'
        return nil
      end

      begin
        response = get_api_instance(plugin, object).read(pulp_href).to_hash
        return response[:name] unless response[:name].nil?
        return response[:repository_version] unless response[:repository_version].nil?
      rescue PulpRpmClient::ApiError => e
        raise Puppet::ParseError, "Exception when calling #{api_instance}->read: #{e}"
      end
    end
  end
end
