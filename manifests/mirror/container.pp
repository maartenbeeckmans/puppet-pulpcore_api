#
#
#
define pulpcore_api::mirror::container (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $upstream_name,
  String                $name_prefix                = 'container-mirror-',
  String                $base_path_prefix           = 'container/pub/mirrors/',
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
  pulpcore_container_container_remote { "${name_prefix}${name}":
    ensure        => $ensure,
    url           => $url,
    policy        => $policy,
    upstream_name => $upstream_name,
    pulp_labels   => merge($pulp_labels_defaults, $pulp_labels),
    *             => $remote_extra_options,
  }

  # Create repository
  pulpcore_container_container_repository { "${name_prefix}${name}":
    ensure      => $ensure,
    remote      => "${name_prefix}${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $repository_extra_options,
  }

  pulpcore_contentguards_container_content_redirect { "${name_prefix}${name}": }

  # Create distribution
  pulpcore_container_container_distribution { "${name_prefix}${name}":
    ensure      => $ensure,
    base_path   => "${base_path_prefix}${base_path}",
    repository  => "${name_prefix}${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-${name_prefix}${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "${name_prefix}${name}",
        'service'     => "sync-${name_prefix}${name}.service",
        'on_calendar' => $timer_on_calendar
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'   => "${name_prefix}${name}",
        'plugin' => 'container'
      }),
    }

    service { "sync-${name_prefix}${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_container_container_remote["${name_prefix}${name}"],
        Pulpcore_container_container_repository["${name_prefix}${name}"],
        Pulpcore_contentguards_container_content_redirect["${name_prefix}${name}"],
        Pulpcore_container_container_distribution["${name_prefix}${name}"],
        Systemd::Timer["sync-${name_prefix}${name}.timer"]
      ],
    }
  }

  Pulpcore_container_container_remote["${name_prefix}${name}"]
  -> Pulpcore_container_container_repository["${name_prefix}${name}"]
  -> Pulpcore_contentguards_container_content_redirect["${name_prefix}${name}"]
  -> Pulpcore_container_container_distribution["${name_prefix}${name}"]
}
