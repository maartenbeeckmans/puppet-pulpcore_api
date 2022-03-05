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
  Hash                  $pulp_labels                = {},
  Hash                  $pulp_labels_defaults       = {'type' => 'mirror' },
) {
  # Create remote
  pulpcore_container_container_remote { "container-mirror-${name}":
    ensure        => $ensure,
    url           => $url,
    policy        => $policy,
    upstream_name => $upstream_name,
    pulp_labels   => merge($pulp_labels_defaults, $pulp_labels),
    *             => $remote_extra_options,
  }

  # Create repository
  pulpcore_container_container_repository { "container-mirror-${name}":
    ensure      => $ensure,
    remote      => "container-mirror-${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $repository_extra_options,
  }

  pulpcore_contentguards_container_content_redirect { "container-mirror-${name}": }

  # Create distribution
  pulpcore_container_container_distribution { "container-mirror-${name}":
    ensure      => $ensure,
    base_path   => $base_path,
    repository  => "container-mirror-${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-container-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "container-mirror-${name}",
        'service'     => "sync-container-mirror-${name}.service",
        'on_calendar' => $timer_on_calendar
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'   => "container-mirror-${name}",
        'plugin' => 'container'
      }),
    }

    service { "sync-container-mirror-${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_container_container_remote["container-mirror-${name}"],
        Pulpcore_container_container_repository["container-mirror-${name}"],
        Pulpcore_contentguards_container_content_redirect["container-mirror-${name}"],
        Pulpcore_container_container_distribution["container-mirror-${name}"],
        Systemd::Timer["sync-container-mirror-${name}.timer"]
      ],
    }
  }

  Pulpcore_container_container_remote["container-mirror-${name}"]
  -> Pulpcore_container_container_repository["container-mirror-${name}"]
  -> Pulpcore_contentguards_container_content_redirect["container-mirror-${name}"]
  -> Pulpcore_container_container_distribution["container-mirror-${name}"]
}
