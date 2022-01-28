require 'pulp_container_client'
require 'puppet'
require 'yaml'

Puppet::Functions.create_function(:'pulpcore::get_pulp_href_pulpcore_contentguards_container_content_redirect') do
  dispatch :get_pulp_href_pulpcore_contentguards_container_content_redirect do
    param 'String', :name
    return_type 'Optional[String]'
  end

  def get_pulp_href_pulpcore_contentguards_container_content_redirect(name)
    apiconfig = YAML.load_file(File.join(Puppet.settings[:confdir], '/pulpcoreapi.yaml'))
    PulpContainerClient.configure do |config|
      config.scheme     = apiconfig['scheme']
      config.host       = apiconfig['host']
      config.ssl_verify = apiconfig['ssl_verify']
      config.username   = apiconfig['username']
      config.password   = apiconfig['password']
    end
    api_instance = PulpContainerClient::ContentguardsContentRedirectApi.new
    begin
      response = api_instance.list({limit: 1, name: name}).to_hash
      if response[:count] != 1
        return :undef
      else
        return response[:results][0][:pulp_href]
      end
    rescue PulpContainerClient::ApiError => e
      raise "Exception when calling PulpContainerClient->list: #{e}"
    end
  end
end
