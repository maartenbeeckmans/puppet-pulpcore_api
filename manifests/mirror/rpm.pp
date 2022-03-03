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
  pulpcore_rpm_rpm_remote { "rpm-mirror-${name}":
    ensure => $ensure,
    url    => $url,
    policy => $policy,
    *      => $remote_extra_options,
  }

  # Create repository
  pulpcore_rpm_rpm_repository { "rpm-mirror-${name}":
    ensure      => $ensure,
    autopublish => true,
    remote      => "rpm-mirror-${name}",
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_rpm_rpm_distribution { "rpm-mirror-${name}":
    ensure     => $ensure,
    base_path  => $base_path,
    repository => "rpm-mirror-${name}",
    *          => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-rpm-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "rpm-mirror-${name}",
        'service'     => "sync-rpm-mirror-${name}.service",
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/mirror/service.epp", {
        'name'   => "rpm-mirror-${name}",
        'plugin' => 'rpm',
        'mirror' => $mirror,
      }),
    }

    service { "sync-rpm-mirror-${name}.timer":
      ensure    => running,
      subscribe => [
        Pulpcore_rpm_rpm_remote["rpm-mirror-${name}"],
        Pulpcore_rpm_rpm_repository["rpm-mirror-${name}"],
        Pulpcore_rpm_rpm_distribution["rpm-mirror-${name}"],
        Systemd::Timer["sync-rpm-mirror-${name}.timer"]
      ],
    }
  }
}
