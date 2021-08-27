require 'puppet/resource_api/simple_provider'
require 'pulp_rpm_client'
require 'puppet'
require 'yaml'

class ::Puppet::Provider::PulpcoreRpmRpmRepository::PulpcoreRpmRpmRepository < Puppet::ResourceApi::SimpleProvider

  def initialize
    apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
    PulpRpmClient.configure do |config|
      config.scheme     = apiconfig['scheme']
      config.host       = apiconfig['host']
      config.ssl_verify = apiconfig['ssl_verify']
      config.username   = apiconfig['username']
      config.password   = apiconfig['password']
    end

    @api_instance = PulpRpmClient::RepositoriesRpmApi.new
    @instances = []
  end

  def get(context)
    if @instances.empty?
      parsed_objects = []
      begin
        @api_instance.list.to_hash[:results].each do |object|
          object[:ensure] = 'present'
          parsed_objects << object
        end
      rescue PulpRpmClient::ApiError => e
        context.err("Exception when calling PulpRpmClient->list: #{e}")
      end
      @instances = parsed_objects
    end
    @instances
  end

  def create(context, name, should)
    begin
      @api_instance.create(hash_to_object(should))
    rescue PulpRpmClient::ApiError => e
      context.err("Exception when calling PulpRpmClient->create[#{name}]: #{e}")
    end
  end

  def update(context, name, should)
    begin
      @api_instance.update(get_pulp_href(name),hash_to_object(should))
    rescue PulpRpmClient::ApiError => e
      context.err("Exception when calling PulpRpmClient->update[#{name}]: #{e}")
    end
  end

  def delete(context, name)
    begin
      @api_instance.delete(get_pulp_href(name))
    rescue PulpRpmClient::ApiError => e
      context.err("Exception when calling PulpRpmClient->delete[#{name}]: #{e}")
    end
  end

  def get_pulp_href(name)
    begin
      response = @api_instance.list({limit: 1, name: name}).to_hash
      if response[:count] != 1
        context.err("Found not exactly 1 object with #{name}, found #{response[:count]}.")
      end
      pulp_href = response[:results][0][:pulp_href]
    rescue PulpRpmClient::ApiError => e
      context.err("Exception when calling PulpRpmClient->list: #{e}")
    end

    pulp_href
  end

  def hash_to_object(hash)
    PulpRpmClient::RpmRpmRepository.new(
      hash.tap { |value| value.delete(:ensure) }
    )
  end
end

