require 'puppet/resource_api/simple_provider'
require 'pulp_file_client'

require_relative '../../../puppet_x/pulpcore/helper'
require_relative '../../../puppet_x/pulpcore/config'

class ::Puppet::Provider::PulpcoreFileRepository::PulpcoreFileRepository < Puppet::ResourceApi::SimpleProvider

  def initialize
    @api_instance = PuppetX::Pulpcore::Config.get_api_instance
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
      rescue PulpFileClient::ApiError => e
        context.err("Exception when calling FileFileClient->list: #{e}")
      end
      @instances = parsed_objects
    end
    @instances
  end

  def create(context, name, should)
    begin
      @api_instance.create(PuppetX::Pulpcore::Helper.hash_to_object(should))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->create[#{name}]: #{e}")
    end
  end

  def update(context, name, should)
    begin
      @api_instance.update(PuppetX::Pulpcore::Helper.get_pulp_href(name),PuppetX::Pulpcore::Helper.hash_to_object(should))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->update[#{name}]: #{e}")
    end
  end

  def delete(context, name)
    begin
      @api_instance.delete(PuppetX::Pulpcore::Helper.get_pulp_href(name))
    rescue PulpFileClient::ApiError => e
      context.err("Exception when calling FileFileClient->delete[#{name}]: #{e}")
    end
  end
end
