#
# @summary This module contains pulpcore api types
#
# @example
#   include ::pulpcore_api
#
# @param pulp_server
#   Server address used for connecting with the pulpcore_api
#   Example: https://pulp.example.com
#
# @param pulp_username
#   Username used for connecting with the pulpcore api
#
# @param pulp_password
#   Password used for connecting with the pulpcore api
#
# @param ssl_verify
#   Verify the ssl certificate when connecting with the pulpcore api
#
# @param manage_api_config
#   Boolean which determines if the api config used by this module should be managed
#
# @param cli_users
#   Hash containing the users for which the cli should be installed together with the cli config.
#   Root is required when defined types for mirrors or promotion trees are used within this module.
#
# @param netrc_users
#   Hash containing the users for which the .netrc file should be managed.
#
# @param manage_agent_gems
#   If the agent gems should be managed
#
# @param agent_gems
#   Hash containing agent gems to install with version
#
# @param resources
#
# @param rpm_rpm_mirrors
#
# @param rpm_rpm_mirror_defaults
#
# @param rpm_rpm_promotion_trees
#
# @param rpm_rpm_promotion_tree_defaults
#
# @param purge_resources
#   Array with resources that should be purged
#   Set to false to not purge any resources
#
class pulpcore_api (
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPSUrl] $pulp_server,
  String                                      $pulp_username,
  String                                      $pulp_password,
  Boolean                                     $ssl_verify,
  Boolean                                     $manage_api_config,
  Hash                                        $cli_users,
  Hash                                        $netrc_users,
  Array[String]                               $cli_packages,
  String                                      $cli_packages_ensure,
  Boolean                                     $manage_agent_gems,
  Hash[String,Hash]                           $agent_gems,
  Optional[Hash[String,Hash]]                 $resources,
  Optional[Hash]                              $container_container_mirrors,
  Hash                                        $container_container_mirror_defaults,
  Optional[Hash]                              $deb_apt_mirrors,
  Hash                                        $deb_apt_mirror_defaults,
  Optional[Hash]                              $file_file_mirrors,
  Hash                                        $file_file_mirror_defaults,
  Optional[Hash]                              $rpm_rpm_mirrors,
  Hash                                        $rpm_rpm_mirror_defaults,
  Optional[Hash]                              $deb_apt_promotion_trees,
  Hash                                        $deb_apt_promotion_tree_defaults,
  Optional[Hash]                              $rpm_rpm_promotion_trees,
  Hash                                        $rpm_rpm_promotion_tree_defaults,
  Variant[Boolean,Array]                      $purge_resources,
  Boolean                                     $autopublish_new_repositories,
) {
  if $manage_agent_gems {
    $agent_gems.each |String $agent_gem_name, Hash $options| {
      package { $agent_gem_name:
        ensure   => $options['version'],
        provider => 'puppet_gem',
      }
    }
  }

  include pulpcore_api::config

  if $resources {
    $resources.each |String $resource_type, Hash $instances| {
      $instances.each |String $resource_name, Hash $resource| {
        ensure_resource("pulpcore_${resource_type}", $resource_name, $resource)
      }
    }
  }

  contain pulpcore_api::mirror
  contain pulpcore_api::tree

  if $purge_resources {
    resources { $purge_resources:
      purge => true,
    }
  }

  if $autopublish_new_repositories {
    contain pulpcore_api::autopublish
  }
}
