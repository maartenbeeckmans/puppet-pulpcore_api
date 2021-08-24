require 'puppet/resource_api/simple_provider'
require 'puppet'
require 'pulp_file_client'
require 'yaml'

class ::Puppet::Provider::PulpcoreFileRepository::PulpcoreFileRepository < Puppet::ResourceApi::SimpleProvider

  def initialize
    apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
    PulpFileClient.configure do |config|
      config.scheme     = apiconfig['scheme']
      config.host       = apiconfig['host']
      config.ssl_verify = apiconfig['ssl_verify']
      config.username   = apiconfig['username']
      config.password   = apiconfig['password']
    end

    @api_instance = PulpFileClient::RepositoriesFileApi.new
    @instances = []
  end

  def hash_to_object(should)
    PulpFileClient::FileFileRepository.new(
      should.tap { |value| value.delete(:ensure) }
    )
  end

  def get(context)
    if @instances.empty?
      parsed_objects = []
      begin
        @api_instance.list.to_hash[:results].each do |object|
          object[:ensure] = 'present'
          parsed_objects << object
        end
      rescue PulpFileClient::ApiError => e
        context.err("Exception when calling FileFileClient->list: #{e}")
      end
      @instances = parsed_objects
    end
    @instances
  end

  def create(context, name, should)
    begin
      @api_instance.create(hash_to_object(should))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->create[#{name}]: #{e}")
    end
  end

  def update(context, name, should)
    begin
      @api_instance.update(get_pulp_href(name),hash_to_object(should))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->update[#{name}]: #{e}")
    end
  end

  def delete(context, name)
    begin
      @api_instance.delete(get_pulp_href(name))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->delete[#{name}]: #{e}")
    end
  end

  def get_pulp_href(name)
    begin
      response = @api_instance.list({limit: 1, name: name}).to_hash
      if response[:count] != 1
        context.err("Found not exactly 1 repository with #{name}, found #{response[:count]}.")
      end
      pulp_href = response[:results][0][:pulp_href]
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->list[#{name}]: #{e}")
    end
    pulp_href
  end
end
