#
#
#
define pulpcore_api::mirror::rpm (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  String                $timer_on_calendar          = 'daily',
  Boolean               $mirror                     = true,
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
) {
  # Create remote
  pulpcore_rpm_rpm_remote { "mirror-${name}":
    ensure => $ensure,
    url    => $url,
    policy => $policy,
    *      => $remote_extra_options,
  }

  # Create repository
  pulpcore_rpm_rpm_repository { "mirror-${name}":
    ensure      => $ensure,
    autopublish => true,
    remote      => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_remote', ["mirror-${name}"]),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_rpm_rpm_distribution { "mirror-${name}":
    ensure     => $ensure,
    base_path  => $base_path,
    repository => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', ["mirror-${name}"]),
    *          => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "mirror-${name}",
        'service'     => "sync-mirror-${name}.service",
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'   => "mirror-${name}",
        'plugin' => 'rpm',
        'mirror' => $mirror,
      }),
    }

    service { "sync-mirror-${name}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["sync-mirror-${name}.timer"],
    }
  }
}
