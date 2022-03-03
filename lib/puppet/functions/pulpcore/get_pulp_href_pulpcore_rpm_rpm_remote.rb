#
# This function is automatically generated
#
# frozen_string_literal: true

begin
  require 'pulp_rpm_client'
rescue LoadError
  Puppet.warning("#{__FILE__}:#{__LINE__}: pulp_rpm_client gem was not found")
end
require 'puppet_x/pulpcore_api/config'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::get_pulp_href_pulpcore_rpm_rpm_remote') do
  dispatch :get_pulp_href_pulpcore_rpm_rpm_remote do
    param 'String', :name
    return_type 'Optional[String]'
  end

  def get_pulp_href_pulpcore_rpm_rpm_remote(name)
    # Add deprication warning as this function should not be used anymore
    # The resources don't require it and custom scripts should use names instead of href's
    Puppet.warning("The function :pulpcore::get_pulp_href_pulpcore_rpm_rpm_remote is depricated and will be removed in a future release.")

    apiconfig = PuppetX::PulpcoreApi::Config.configure
    PulpRpmClient.configure do |config|
      config.scheme     = apiconfig[:scheme]
      config.host       = apiconfig[:host]
      config.ssl_verify = apiconfig[:ssl_verify]
      config.username   = apiconfig[:username]
      config.password   = apiconfig[:password]
    end
    api_instance = PulpRpmClient::RemotesRpmApi.new
    begin
      response = api_instance.list({ limit: 1, name: name }).to_hash
      return :undef if response[:count] != 1
      response[:results][0][:pulp_href]
    rescue PulpRpmClient::ApiError => e
      raise "Exception when calling PulpRpmClient->list: #{e}"
    end
  end
end
