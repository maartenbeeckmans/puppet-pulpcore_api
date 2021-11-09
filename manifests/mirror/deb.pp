#
#
#
define pulpcore_api::mirror::deb (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $distributions,
  String                $components,
  String                $architectures,
  Boolean               $sync_sources               = false,
  Boolean               $sync_udebs                 = false,
  Boolean               $sync_installer             = false,
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  Boolean               $mirror                     = true,
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
) {
  # Create remote
  pulpcore_deb_apt_remote { "mirror-${name}":
    ensure         => $ensure,
    url            => $url,
    distributions  => $distributions,
    components     => $components,
    architectures  => $architectures,
    sync_sources   => $sync_sources,
    sync_udebs     => $sync_udebs,
    sync_installer => $sync_installer,
    *              => $remote_extra_options,
  }

  # Create repository
  pulpcore_deb_apt_repository { "mirror-${name}":
    ensure => $ensure,
    remote => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_remote', ["mirror-${name}"]),
    *      => $repository_extra_options,
  }

  # Create distribution
  pulpcore_deb_apt_distribution { "mirror-${name}":
    ensure     => $ensure,
    base_path  => $base_path,
    repository => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', ["mirror-${name}"]),
    *          => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "mirror-${name}",
        'service'     => "sync-mirror-${name}.service",
        'on_calendar' => 'daily'
      }),
      service_content => epp("${module_name}/mirror/service_deb.epp", {
        'remote_href'       => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_remote', ["mirror-${name}"]),
        'repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', ["mirror-${name}"]),
        'distribution_href' => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_distribution', ["mirror-${name}"]),
        'name'              => "mirror-${name}",
        'plugin'            => 'deb'
      }),
    }

    service { "sync-mirror-${name}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["sync-mirror-${name}.timer"],
    }
  }
}
