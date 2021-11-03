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
#   Hash containing agent gems to install with version
#
# @param resources
#
# @param rpm_rpm_mirrors
#
# @param rpm_rpm_mirror_defaults
#
# @param rpm_rpm_trees
#
# @param rpm_rpm_tree_defaults
#
# @param purge_resources
#   Array with resources that should be purged
#   Set to false to not purge any resources
#
class pulpcore_api (
  Boolean                $manage_agent_gems,
  Hash[String,Hash]      $agent_gems,
  Hash[String,Hash]      $resources,
  Hash                   $container_container_mirrors,
  Hash                   $container_container_mirror_defaults,
  Hash                   $deb_apt_mirrors,
  Hash                   $deb_apt_mirror_defaults,
  Hash                   $file_file_mirrors,
  Hash                   $file_file_mirror_defaults,
  Hash                   $rpm_rpm_mirrors,
  Hash                   $rpm_rpm_mirror_defaults,
  Hash                   $rpm_rpm_trees,
  Hash                   $rpm_rpm_tree_defaults,
  Variant[Boolean,Array] $purge_resources,
) {
  if $manage_agent_gems {
    $agent_gems.each |String $agent_gem_name, Hash $options| {
      package { $agent_gem_name:
        ensure   => $options['version'],
        provider => 'puppet_gem',
      }
    }
  }

  $resources.each |String $resource_type, Hash $instances| {
    $instances.each |String $resource_name, Hash $resource| {
      ensure_resource("pulpcore_${resource_type}", $resource_name, $resource)
    }
  }

  create_resources(pulpcore_api::mirror::container, $container_container_mirrors, $container_container_mirror_defaults)
  create_resources(pulpcore_api::mirror::deb, $deb_apt_mirrors, $deb_apt_mirror_defaults)
  create_resources(pulpcore_api::mirror::file, $file_file_mirrors, $file_file_mirror_defaults)
  create_resources(pulpcore_api::mirror::rpm, $rpm_rpm_mirrors, $rpm_rpm_mirror_defaults)

  create_resources(pulpcore_api::tree::rpm, $rpm_rpm_trees, $rpm_rpm_tree_defaults)

  if $purge_resources {
    resources { $purge_resources:
      purge => true,
    }
  }
}
