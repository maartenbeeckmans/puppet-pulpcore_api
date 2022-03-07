#
#
#
define pulpcore_api::mirror::deb (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $distributions,
  String                $name_prefix                = 'deb-mirror-',
  String                $base_path_prefix           = 'deb/pub/mirrors/',
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
  pulpcore_deb_apt_remote { "${name_prefix}${name}":
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
  pulpcore_deb_apt_repository { "${name_prefix}${name}":
    ensure      => $ensure,
    remote      => "${name_prefix}${name}",
    pulp_labels => merge($pulp_labels_defaults, $pulp_labels),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_deb_apt_distribution { "${name_prefix}${name}":
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
        'name'   => "${name_prefix}${name}",
        'plugin' => 'deb',
        'mirror' => $mirror,
      }),
    }

    service { "sync-${name_prefix}${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_deb_apt_remote["${name_prefix}${name}"],
        Pulpcore_deb_apt_repository["${name_prefix}${name}"],
        Pulpcore_deb_apt_distribution["${name_prefix}${name}"],
        Systemd::Timer["sync-${name_prefix}${name}.timer"]
      ],
    }
  }

  Pulpcore_deb_apt_remote["${name_prefix}${name}"]
  -> Pulpcore_deb_apt_repository["${name_prefix}${name}"]
  -> Pulpcore_deb_apt_distribution["${name_prefix}${name}"]
}
