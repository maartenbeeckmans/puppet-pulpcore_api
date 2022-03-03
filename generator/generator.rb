#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'json'
require 'erb'
require 'colorize'
require 'yaml'
require 'fileutils'

# Module config of generator
module Config
  class << self
    attr_reader :apidocbasepath, :typemap, :generator_config, :typetemplate, :typespectemplate, :providertemplate, :providerspectemplate, :gethreffunctiontemplate, :gethreffunctionspectemplate
  end

  # Path to the api file
  @apidocbasepath = './api.json'

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

  # ERB template files file
  @generator_config = YAML.load_file('config.yaml')
  @typetemplate = ERB.new(File.read('type.rb.erb'), nil, '-')
  @typespectemplate = ERB.new(File.read('type_spec.rb.erb'), nil, '-')
  @providertemplate = ERB.new(File.read('provider.rb.erb'), nil, '-')
  @providerspectemplate = ERB.new(File.read('provider_spec.rb.erb'), nil, '-')
  @hreffunctiontemplate = ERB.new(File.read('get_pulp_href_function.rb.erb'), nil, '-')
  @gethreffunctiontemplate = ERB.new(File.read('get_pulp_href_function.rb.erb'), nil, '-')
  @gethreffunctionspectemplate = ERB.new(File.read('get_pulp_href_function_spec.rb.erb'), nil, '-')
end

# Class that defines a pulpcore api endpoint
class Endpoint
  def initialize
    # Try reading and psrsing the json api config
    begin
      api_config_file = File.read(Config.apidocbasepath)
      @api_config_data = JSON.parse(api_config_file)
    rescue
      @api_config_data = {}
    end
    # Start the generation process with the parsed api config
    _generate(@api_config_data)
  end

  # Helper function for printing api config output
  def _print_hash(hash)
    puts JSON.pretty_generate(hash).light_blue
  end

  # Main generator function
  def _generate(api_config_hash)
    # Looping over all resources defined in the configuration file
    Config.generator_config['resources'].each do |resource|
      puts '----------------------------------------'.blue
      puts "Generating resource #{resource['name']}".blue
      config_hash = _create_config_hash(resource, api_config_hash)
      _print_hash(config_hash)
      _gentype(config_hash)
      _gentypespec(config_hash)
      _genprovider(config_hash)
      _genproviderspec(config_hash)
      _gengethreffunction(config_hash)
      _gengethreffunctionspec(config_hash)
      puts '----------------------------------------'.blue
    end
  end

  # Helper function that will generate a config hash that's used by the erb templates
  def _create_config_hash(resource, api_config_hash)
    config_hash = {}
    config_hash['name'] = resource['name']
    config_hash['providername'] = resource['name'].split(%r{/ |\_|\-/}).map(&:capitalize).join('')
    config_hash['client_import'] = resource['client_binding']
    config_hash['client_binding'] = resource['client_binding'].split(%r{/ |\_|\-/}).map(&:capitalize).join('')
    config_hash['client_binding_api'] = resource['client_binding_api']
    config_hash['client_binding_model'] = resource['client_binding_model']
    config_hash['description'] = "Resource for creating #{resource['name']}"
    attributearray_namevar = []
    attributearray_normal = []
    attributearray_read_only = []
    api_config_hash['components']['schemas'][resource['schema']]['properties'].each do |attribute|
      attributemap = {}
      attributemap['name'] = attribute[0]
      if !attribute[1]['allOf'].nil?
        attributemap['type'] = "Enum[#{api_config_hash['components']['schemas'][attribute[1]['allOf'][0]['$ref'].split('/')[-1]]['enum'].join(',')}]"
        if !attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{attributemap['type']}]"
        else
          attributemap['default'] = api_config_hash['components']['schemas'][attribute[1]['allOf'][0]['$ref'].split('/')[-1]]['enum'][-1]
        end
      elsif !attribute[1]['oneOf'].nil?
        attributemap['type'] = "Enum[#{api_config_hash['components']['schemas'][attribute[1]['oneOf'][0]['$ref'].split('/')[-1]]['enum'].join(',')}]"
        if !attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{attributemap['type']}]"
        else
          attributemap['default'] = api_config_hash['components']['schemas'][attribute[1]['oneOf'][0]['$ref'].split('/')[-1]]
        end
      else
        attributemap['type'] = if !attribute[1]['nullable'].nil?
                                 "Optional[#{Config.typemap[attribute[1]['type']]}]"
                               else
                                 Config.typemap[attribute[1]['type']].to_s
                               end
        if attribute[1]['type'] == 'boolean'
          attributemap['default'] = false
        end
        if attribute[1]['type'] == 'integer' && attribute[1]['nullable'].nil?
          attributemap['default'] = 0
        end
        if attribute[1]['type'] == 'object'
          attributemap['default'] = {}
        end
        if attribute[1]['type'] == 'array'
          attributemap['default'] = []
        end
      end
      attributemap['description'] = if !attribute[1]['description'].nil?
                                      attribute[1]['description'].tr("'", '`').tr("\r\n\t", ' ').squeeze(' ')
                                    else
                                      attribute[0]
                                    end
      unless attribute[1]['default'].nil?
        attributemap['default'] = attribute[1]['default']
      end
      if attribute[1]['format'] == 'date-time'
        attributemap['type'] = 'Runtime'
      end
      if attribute[1]['type'] == 'string' and attribute[1]['format'] == 'uri' and attribute[1]['readOnly'].nil?
        attributemap['get_pulp_href_function'] = {
          plugin: resource['client_binding'].split(%r{/ |\_|\-/})[1],
          object: attribute[0]
        }
      end
      if attribute[0] == resource['namevar']
        attributemap['behaviour'] = ':namevar'
        attributearray_namevar << attributemap
      elsif !attribute[1]['readOnly'].nil?
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

  def _gentypespec(config_hash)
    puts "Generating type spec ../spec/unit/puppet/type/#{config_hash['name']}_spec.rb".green
    File.open("../spec/unit/puppet/type/#{config_hash['name']}_spec.rb", 'w') do |f|
      f.write Config.typespectemplate.result(binding)
    end
  end

  def _genprovider(config_hash)
    puts "Generating provider ../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb".green
    FileUtils.mkdir_p "../lib/puppet/provider/#{config_hash['name']}"
    File.open("../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.providertemplate.result(binding)
    end
  end

  def _genproviderspec(config_hash)
    puts "Generating provider spec ../spec/unit/puppet/provider/#{config_hash['name']}/#{config_hash['name']}_spec.rb".green
    FileUtils.mkdir_p "../spec/unit/puppet/provider/#{config_hash['name']}"
    File.open("../spec/unit/puppet/provider/#{config_hash['name']}/#{config_hash['name']}_spec.rb", 'w') do |f|
      f.write Config.providerspectemplate.result(binding)
    end
  end

  def _gengethreffunction(config_hash)
    puts "Generating get_pulp_href_function ../lib/puppet/functions/pulpcore/#{config_hash['name']}.rb".green
    File.open("../lib/puppet/functions/pulpcore/get_pulp_href_#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.gethreffunctiontemplate.result(binding)
    end
  end

  def _gengethreffunctionspec(config_hash)
    puts "Generating get_pulp_href_function_spec ../spec/functions/pulpcore/#{config_hash['name']}_spec.rb".green
    File.open("../spec/functions/pulpcore/get_pulp_href_#{config_hash['name']}_spec.rb", 'w') do |f|
      f.write Config.gethreffunctionspectemplate.result(binding)
    end
  end
end

Endpoint.new
