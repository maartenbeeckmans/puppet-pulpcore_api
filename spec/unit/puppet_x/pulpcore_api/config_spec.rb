# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../../lib/puppet_x/pulpcore_api/config'

module PuppetX::PulpcoreApi
  describe Config do
    let(:scheme) { 'https' }
    let(:host) { 'pulp.example.com' }
    let(:ssl_verify) { true }
    let(:username) { 'admin' }
    let(:password) { 'secret' }
    let(:full_config) do
      {
        'scheme'     => scheme,
        'host'       => host,
        'ssl_verify' => ssl_verify,
        'username'   => username,
        'password'   => password
      }
    end

    before(:each) do
      described_class.reset
    end

    describe 'self.file_path' do
      specify 'should retrieve Puppet\'s configurion directory from the API' do
        Puppet.settings[:confdir] = '/etc/puppetlabs/puppet'
        expect(described_class.file_path).to eq('/etc/puppetlabs/puppet/pulpcoreapi.yaml')
      end

      specify 'should cache the filename' do
        expect(described_class.file_path).to be(described_class.file_path)
      end
    end

    describe 'self.read_config' do
      specify 'should raise an error if file does not exist' do
        allow(YAML).to receive(:load_file).and_raise('file not found')
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{file not found})
      end

      specify 'should read scheme' do
        allow(YAML).to receive(:load_file).and_return(full_config)
        expect(described_class.read_config[:scheme]).to be('https')
      end

      specify 'should raise an error if scheme is missing' do
        allow(YAML).to receive(:load_file).and_return(full_config.reject { |key, _| key == 'scheme' })
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{must contain a value for key 'scheme'})
      end

      specify 'should read host' do
        allow(YAML).to receive(:load_file).and_return(full_config)
        expect(described_class.read_config[:host]).to be('pulp.example.com')
      end

      specify 'should raise an error if host is missing' do
        allow(YAML).to receive(:load_file).and_return(full_config.reject { |key, _| key == 'host' })
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{must contain a value for key 'host'})
      end

      specify 'should read ssl_verify flag (false case)' do
        allow(YAML).to receive(:load_file).and_return(full_config.merge({ 'ssl_verify' => false }))
        expect(described_class.read_config[:ssl_verify]).to be_falsey
      end

      specify 'should read ssl_verify flag (true case)' do
        allow(YAML).to receive(:load_file).and_return(full_config.merge({ 'ssl_verify' => true }))
        expect(described_class.read_config[:ssl_verify]).to be_truthy
      end

      specify 'should raise an error if ssl_verify is missing' do
        allow(YAML).to receive(:load_file).and_return(full_config.reject { |key, _| key == 'ssl_verify' })
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{must contain a value for key 'ssl_verify'})
      end

      specify 'should read username' do
        allow(YAML).to receive(:load_file).and_return(full_config)
        expect(described_class.read_config[:username]).to be('admin')
      end

      specify 'should raise an error if username is missing' do
        allow(YAML).to receive(:load_file).and_return(full_config.reject { |key, _| key == 'username' })
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{must contain a value for key 'username'})
      end

      specify 'should read password' do
        allow(YAML).to receive(:load_file).and_return(full_config)
        expect(described_class.read_config[:password]).to be('secret')
      end

      specify 'should raise an error if password is missing' do
        allow(YAML).to receive(:load_file).and_return(full_config.reject { |key, _| key == 'password' })
        expect { described_class.read_config }.to raise_error(Puppet::ParseError, %r{must contain a value for key 'password'})
      end
    end
  end
end
