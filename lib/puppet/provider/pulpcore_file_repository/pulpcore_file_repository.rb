require 'puppet/resource_api/simple_provider'
require 'pulpcore_client'

class ::Puppet::Provider::PulpcoreFileRepository::PulpcoreFileRepository < Puppet::ResourceApi::SimpleProvider
  #def initialize
  #  # Setup authorization
  #  PulpcoreClient.configure do |config|
  #    # Configure HTTP basic authorization: basicAuth
  #    config.username = 'admin'
  #    config.password = 'secret'
  #  end
  #end

  def get(context)
    context.info("Called get")
  end

  # Needed function for simple provider
  # context: provides utilities from the runtime environment
  # name: the name of the new resource
  # should: a hash of the attributes for the new resource
  def create(context, name, should)
    context.info("Called create")
    #api_instance = PulpFileClient::RepositoriesFileApi.new
    #file_file_repository = PulpFileClient::FileFileRepository.new

    #begin
    #  result = api_instance.create(file_file_repository)
    #  context.info("Created #{result}")
    #rescue PulpFileClient::ApiError => e
    #  context.error("Exception when calling RepositoriesFileApi->create: #{e}")
    #end
  end

  # Needed function for simple provideFileRepository
  # context: provides utilities from the runtime environment
  # name: the name of the new resource
  # should: a hash of the attributes for the new resource
  def update(context, name, should)
    context.info("Called update")
  end

  # Needed function for simple provider
  # context: provides utilities from the runtime environment
  # name: the name of the new resource
  def delete(context, name)
    context.info("Called delete")
  end
end
#api_instance = PulpcoreClient::AccessPoliciesApi.new
#opts = {
#  customized: true, # Boolean |
#  limit: 56, # Integer | Number of results to return per page.
#  offset: 56, # Integer | The initial index from which to return the results.
#  ordering: 'ordering_example', # String | Which field to use when ordering the results.
#  viewset_name: 'viewset_name_example', # String | Filter results where viewset_name matches value
#  viewset_name__contains: 'viewset_name__contains_example', # String | Filter results where viewset_name contains value
#  viewset_name__icontains: 'viewset_name__icontains_example', # String | Filter results where viewset_name contains value
#  viewset_name__in: ['viewset_name__in_example'], # Array<String> | Filter results where viewset_name is in a comma-separated list of values
#  viewset_name__startswith: 'viewset_name__startswith_example', # String | Filter results where viewset_name starts with value
#  fields: 'fields_example', # String | A list of fields to include in the response.
#  exclude_fields: 'exclude_fields_example' # String | A list of fields to exclude from the response.
#}
#
#begin
#  #List access policys
#  result = api_instance.list(opts)
#  p result
#rescue PulpcoreClient::ApiError => e
#  puts "Exception when calling AccessPoliciesApi->list: #{e}"
#end
