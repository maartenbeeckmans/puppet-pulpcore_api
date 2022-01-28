require 'pulp_rpm_client'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::get_pulp_href_pulpcore_rpm_rpm_publication') do
  dispatch :get_pulp_href_pulpcore_rpm_rpm_publication do
    param 'String', :name
    return_type 'Optional[String]'
  end

  def get_pulp_href_pulpcore_rpm_rpm_publication(name)
    apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
    PulpRpmClient.configure do |config|
      config.scheme     = apiconfig['scheme']
      config.host       = apiconfig['host']
      config.ssl_verify = apiconfig['ssl_verify']
      config.username   = apiconfig['username']
      config.password   = apiconfig['password']
    end
    api_instance = PulpRpmClient::PublicationsRpmApi.new
    begin
      response = api_instance.list({limit: 1, name: name}).to_hash
      if response[:count] != 1
        return :undef
      else
        return response[:results][0][:pulp_href]
      end
    rescue PulpRpmClient::ApiError => e
      raise "Exception when calling PulpRpmClient->list: #{e}"
    end
  end
end
