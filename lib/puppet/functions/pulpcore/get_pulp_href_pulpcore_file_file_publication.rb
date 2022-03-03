#
# This function is automatically generated
#
# frozen_string_literal: true

begin
  require 'pulp_file_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_file_client gem was not found")
end
require 'puppet_x/pulpcore_api/config'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::get_pulp_href_pulpcore_file_file_publication') do
  dispatch :get_pulp_href_pulpcore_file_file_publication do
    param 'String', :name
    return_type 'Optional[String]'
  end

  def get_pulp_href_pulpcore_file_file_publication(name)
    # Add deprication warning as this function should not be used anymore
    # The resources don't require it and custom scripts should use names instead of href's
    Puppet.warning("The function :pulpcore::get_pulp_href_pulpcore_file_file_publication is depricated and will be removed in a future release.")

    apiconfig = PuppetX::PulpcoreApi::Config.configure
    PulpFileClient.configure do |config|
      config.scheme     = apiconfig[:scheme]
      config.host       = apiconfig[:host]
      config.ssl_verify = apiconfig[:ssl_verify]
      config.username   = apiconfig[:username]
      config.password   = apiconfig[:password]
    end
    api_instance = PulpFileClient::PublicationsFileApi.new
    begin
      response = api_instance.list({ limit: 1, name: name }).to_hash
      return :undef if response[:count] != 1
      response[:results][0][:pulp_href]
    rescue PulpFileClient::ApiError => e
      raise "Exception when calling PulpFileClient->list: #{e}"
    end
  end
end
