# frozen_string_literal: true

require 'yaml'
require 'puppet'

module PuppetX::PulpcoreApi
  class Config # rubocop:disable Style/Documentation
    CONFIG_PULPCORE_SCHEME = :scheme
    CONFIG_PULPCORE_HOST = :host
    CONFIG_PULPCORE_SSL_VERIFY = :ssl_verify
    CONFIG_PULPCORE_USERNAME = :username
    CONFIG_PULPCORE_PASSWORD = :password

    def self.configure
      @config ||= read_config
    end

    def self.file_path
      @config_file_path ||= File.expand_path(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
    end

    def self.reset
      @config = nil
      @config_file_path = nil
    end

    def self.read_config
      begin
        Puppet.debug("Parsing configuration file #{file_path}")
        config = {}
        # Ugly hack to convert hash keys from String to Symbol
        YAML.load_file(file_path).each { |key, value| config[key.to_sym] = value }
      rescue => e
        raise Puppet::ParseError, "Could not parse YAML configuration file '#{file_path}': #{e}"
      end

      if config[CONFIG_PULPCORE_SCHEME].nil?
        raise Puppet::ParseError, "Config file #{file_path} must contain a value for key '#{CONFIG_PULPCORE_SCHEME}'"
      end

      if config[CONFIG_PULPCORE_HOST].nil?
        raise Puppet::ParseError, "Config file #{file_path} must contain a value for key '#{CONFIG_PULPCORE_HOST}'"
      end

      if config[CONFIG_PULPCORE_SCHEME] == 'http' && config[CONFIG_PULPCORE_HOST] != 'localhost'
        Puppet.warning 'insecure connection, sending credentials over http'
      end

      if config[CONFIG_PULPCORE_SSL_VERIFY].nil?
        raise Puppet::ParseError, "Config file #{file_path} must contain a value for key '#{CONFIG_PULPCORE_SSL_VERIFY}'"
      end

      if config[CONFIG_PULPCORE_USERNAME].nil?
        raise Puppet::ParseError, "Config file #{file_path} must contain a value for key '#{CONFIG_PULPCORE_USERNAME}'"
      end

      if config[CONFIG_PULPCORE_PASSWORD].nil?
        raise Puppet::ParseError, "Config file #{file_path} must contain a value for key '#{CONFIG_PULPCORE_PASSWORD}'"
      end

      Puppet.warning 'insecure connection, sending credentials over http'
      config
    end
  end
end
