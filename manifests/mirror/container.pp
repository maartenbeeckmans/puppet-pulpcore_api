#
#
#
define pulpcore_api::mirror::container (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $upstream_name,
  Array                 $include_tags               = [],
  Array                 $exclude_tags               = [],
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  String                $timer_on_calendar          = 'daily',
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
) {
  # Create remote
  pulpcore_container_container_remote { "container-mirror-${name}":
    ensure        => $ensure,
    url           => $url,
    policy        => $policy,
    upstream_name => $upstream_name,
    *             => $remote_extra_options,
  }

  # Create repository
  pulpcore_container_container_repository { "container-mirror-${name}":
    ensure      => $ensure,
    remote      => Deferred('pulpcore::get_pulp_href_pulpcore_container_container_remote', ["container-mirror-${name}"]),
    *           => $repository_extra_options,
  }

  pulpcore_contentguards_container_content_redirect { "container-mirror-${name}": }

  # Create distribution
  pulpcore_container_container_distribution { "container-mirror-${name}":
    ensure        => $ensure,
    base_path     => $base_path,
    repository    => Deferred('pulpcore::get_pulp_href_pulpcore_container_container_repository', ["container-mirror-${name}"]),
    #content_guard => Deferred('pulpcore::get_pulp_href_pulpcore_contentguards_container_content_redirect', ["container-mirror-${name}"]),
    *             => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-container-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {'name' => "container-mirror-${name}", 'service' => "sync-container-mirror-${name}.service", 'on_calendar' => $timer_on_calendar}),
      service_content => epp("${module_name}/mirror/service.epp", {'name' => "container-mirror-${name}", 'plugin' => 'container'}),
    }

    service { "sync-container-mirror-${name}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["sync-container-mirror-${name}.timer"],
    }
  }

  Pulpcore_container_container_remote["container-mirror-${name}"] 
  -> Pulpcore_container_container_repository["container-mirror-${name}"]
  -> Pulpcore_contentguards_container_content_redirect["container-mirror-${name}"]
  -> Pulpcore_container_container_distribution["container-mirror-${name}"]
}
