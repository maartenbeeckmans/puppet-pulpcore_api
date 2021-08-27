#!/usr/bin/env ruby

require 'json'
require 'erb'
require 'colorize'
require 'yaml'
require 'fileutils'

module Config
  class << self
    attr_reader :apidocbasepath, :typemap, :generator_config, :typetemplate, :providertemplate
  end

  # Path to the api file
  @apidocbasepath = 'api.json'

  # Translation map for data types
  @typemap = {
    'string' => 'String',
    'integer' => 'Integer',
    'number' => 'Integer',
    'boolean' => 'Boolean',
    'array' => 'Array',
    'numeric' => 'Numeric',
    'object' => 'Hash',
  }

  # Configuration file
  @generator_config = YAML.load_file("config.yaml")
  @typetemplate = ERB.new(File.read('type.rb.erb'), nil, '-')
  @providertemplate = ERB.new(File.read('provider.rb.erb'), nil, '-')
end

class Endpoint
  def initialize()
    begin
      api_config_file = File.open Config.apidocbasepath
      @api_config_data = JSON.load api_config_file
      api_config_file.close
    rescue
      api_config_data = {}
    end
    _generate(@api_config_data)
  end

  def _print_hash(hash)
    puts JSON.pretty_generate(hash).light_blue
  end

  def _generate(api_config_hash)
    Config.generator_config['resources'].each do |resource|
      puts '----------------------------------------'.blue
      puts "Generating resource #{resource['name']}".blue
      config_hash = _create_config_hash(resource, api_config_hash)
      _print_hash(config_hash)
      _gentype(config_hash)
      _genprovider(config_hash)
      puts '----------------------------------------'.blue
    end
  end

  def _create_config_hash(resource, api_config_hash)
    config_hash = Hash.new
    config_hash['name'] = resource['name']
    config_hash['providername'] = resource['name']
      .split(/ |\_|\-/).map(&:capitalize).join("")
    config_hash['client_import'] = resource['client_binding']
    config_hash['client_binding'] = resource['client_binding']
      .split(/ |\_|\-/).map(&:capitalize).join("")
    config_hash['client_binding_api'] = resource['client_binding_api']
    config_hash['client_binding_model'] = resource['client_binding_model']
    config_hash['description'] = "Resource for creating #{resource['name']}"
    config_hash['description'] = "Resource for creating #{resource['name']}"
    attributearray = Array.new
    attributearray_namevar = Array.new
    attributearray_normal = Array.new
    attributearray_read_only = Array.new
    api_config_hash['components']['schemas'][resource['schema']]['properties'].each do |attribute|
      attributemap = Hash.new
      attributemap['name'] = attribute[0]
      if not attribute[1]['allOf'].nil?
        attributemap['type'] = "Enum[#{api_config_hash['components']['schemas'][attribute[1]['allOf'][0]['$ref'].split('/')[-1]]['enum'].join(',')}]"
        if not attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{attributemap['type']}]"
        else
          attributemap['default'] = api_config_hash['components']['schemas'][attribute[1]['allOf'][0]['$ref'].split('/')[-1]]['enum'][-1]
        end
      elsif not attribute[1]['oneOf'].nil?
        attributemap['type'] = "Enum[#{api_config_hash['components']['schemas'][attribute[1]['oneOf'][0]['$ref'].split('/')[-1]]['enum'].join(',')}]"
        if not attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{attributemap['type']}]"
        else
          attributemap['default'] = api_config_hash['components']['schemas'][attribute[1]['oneOf'][0]['$ref'].split('/')[-1]]
        end
      else
        if not attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{Config.typemap[attribute[1]['type']]}]"
        else
          attributemap['type'] = "#{Config.typemap[attribute[1]['type']]}"
        end
        if attribute[1]['type'] == 'boolean'
          attributemap['default'] = false
        end
        if attribute[1]['type'] == 'object'
          attributemap['default'] = {}
        end
        if attribute[1]['type'] == 'array'
          attributemap['default'] = []
        end
      end
      if not attribute[1]['description'].nil?
        attributemap['description'] = attribute[1]['description'].gsub("'", '`').gsub(/\s+/, ' ')
      else
        attributemap['description'] = attribute[0]
      end
      if not attribute[1]['default'].nil?
        attributemap['default'] = attribute[1]['default']
      end
      if attribute[1]['format'] == 'date-time'
        attributemap['type'] = 'Runtime'
      end
      if attribute[0] == resource['namevar']
        attributemap['behaviour'] = ':namevar'
        attributearray_namevar << attributemap 
      elsif not attribute[1]['readOnly'].nil?
        attributemap['behaviour'] = ':read_only'
        attributearray_read_only << attributemap
      else
        attributearray_normal << attributemap
      end
    end
    # Ordering is important for type
    attributearray = attributearray_namevar + attributearray_normal + attributearray_read_only
    config_hash['attributes'] = attributearray
    config_hash
  end

  def _gentype(config_hash)
    puts "Generating type ../lib/puppet/type/#{config_hash['name']}.rb".green
    File.open("../lib/puppet/type/#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.typetemplate.result(binding)
    end
  end

  def _genprovider(config_hash)
    puts "Generating provider ../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb".green
    FileUtils.mkdir_p "../lib/puppet/provider/#{config_hash['name']}"
    File.open("../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.providertemplate.result(binding)
    end
  end
end

Endpoint.new

