#
# @summary This module contains pulpcore api types
#
# @example
#   include ::pulpcore_api
#
# @param manage_agent_gems
#   If the agent gems should be managed
#
# @param agent_gems
#   Array containing list of agent gems to install
#
# @param resources
#
class pulpcore_api (
  Boolean           $manage_agent_gems,
  Array[String]     $agent_gems,
  Hash[String,Hash] $resources,
) {
  if $manage_agent_gems {
    package { $agent_gems:
      ensure   => installed,
      provider => 'puppet_gem',
    }
  }

  $resources.each |String $resource_type, Hash $instances| { 
    $instances.each |String $resource_name, Hash $resource| {
      ensure_resource("pulpcore_${resource_type}", $resource_name, $resource)
    }
  }
}
