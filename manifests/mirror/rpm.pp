#
#
#
define pulpcore_api::mirror::rpm (
  Stdlib::HTTPUrl               $url,
  String                        $base_path,
  String                        $name_prefix                = 'rpm-mirror-',
  String                        $base_path_prefix           = 'rpm/pub/mirrors/',
  Enum[present, absent]         $ensure                     = 'present',
  String                        $policy                     = 'immediate',
  Boolean                       $manage_timer               = true,
  String                        $timer_on_calendar          = 'daily',
  Boolean                       $mirror                     = false,
  Pulpcore_api::Rpm_sync_policy $sync_policy                = 'additive',
  Hash                          $remote_extra_options       = {},
  Hash                          $repository_extra_options   = {},
  Hash                          $distribution_extra_options = {},
  Hash                          $pulp_labels                = {},
  Hash                          $pulp_labels_defaults       = { 'type' => 'mirror' },
) {
  # Create remote
  pulpcore_rpm_rpm_remote { "${name_prefix}${name}":
    ensure      => $ensure,
    url         => $url,
    policy      => $policy,
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $remote_extra_options,
  }

  # Create repository
  pulpcore_rpm_rpm_repository { "${name_prefix}${name}":
    ensure      => $ensure,
    autopublish => true,
    remote      => "${name_prefix}${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_rpm_rpm_distribution { "${name_prefix}${name}":
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
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'        => "${name_prefix}${name}",
        'plugin'      => 'rpm',
        'mirror'      => $mirror,
        'sync_policy' => $sync_policy,
      }),
    }

    service { "sync-${name_prefix}${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_rpm_rpm_remote["${name_prefix}${name}"],
        Pulpcore_rpm_rpm_repository["${name_prefix}${name}"],
        Pulpcore_rpm_rpm_distribution["${name_prefix}${name}"],
        Systemd::Timer["sync-${name_prefix}${name}.timer"]
      ],
    }
  }
}
