#
#
#
define pulpcore_api::mirror::deb (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $distributions,
  Optional[String]      $components                 = undef,
  Optional[String]      $architectures              = undef,
  Boolean               $sync_sources               = false,
  Boolean               $sync_udebs                 = false,
  Boolean               $sync_installer             = false,
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  String                $timer_on_calendar          = 'daily',
  Boolean               $mirror                     = true,
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
  Hash                  $pulp_labels                = {},
  Hash                  $pulp_labels_defaults       = { 'type' => 'mirror' },
) {

  # Create remote
  pulpcore_deb_apt_remote { "deb-mirror-${name}":
    ensure         => $ensure,
    url            => $url,
    policy         => $policy,
    distributions  => $distributions,
    components     => $components,
    architectures  => $architectures,
    sync_sources   => $sync_sources,
    sync_udebs     => $sync_udebs,
    sync_installer => $sync_installer,
    pulp_labels    => merge($pulp_labels_defaults, $pulp_labels),
    *              => $remote_extra_options,
  }

  # Create repository
  pulpcore_deb_apt_repository { "deb-mirror-${name}":
    ensure      => $ensure,
    remote      => "deb-mirror-${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_deb_apt_distribution { "deb-mirror-${name}":
    ensure      => $ensure,
    base_path   => $base_path,
    repository  => "deb-mirror-${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-deb-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "deb-mirror-${name}",
        'service'     => "sync-deb-mirror-${name}.service",
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'   => "deb-mirror-${name}",
        'plugin' => 'deb',
        'mirror' => $mirror,
      }),
    }

    service { "sync-deb-mirror-${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_deb_apt_remote["deb-mirror-${name}"],
        Pulpcore_deb_apt_repository["deb-mirror-${name}"],
        Pulpcore_deb_apt_distribution["deb-mirror-${name}"],
        Systemd::Timer["sync-deb-mirror-${name}.timer"]
      ],
    }
  }

  Pulpcore_deb_apt_remote["deb-mirror-${name}"]
  -> Pulpcore_deb_apt_repository["deb-mirror-${name}"]
  -> Pulpcore_deb_apt_distribution["deb-mirror-${name}"]
}
