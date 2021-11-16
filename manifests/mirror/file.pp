#
#
#
define pulpcore_api::mirror::file (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  String                $timer_on_calendar          = 'daily',
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
) {
  # Create remote
  pulpcore_file_file_remote { "file-mirror-${name}":
    ensure => $ensure,
    url    => $url,
    policy => $policy,
    *      => $remote_extra_options,
  }

  # Create repository
  pulpcore_file_file_repository { "file-mirror-${name}":
    ensure      => $ensure,
    autopublish => true,
    remote      => Deferred('pulpcore::get_pulp_href_pulpcore_file_file_remote', ["file-mirror-${name}"]),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_file_file_distribution { "file-mirror-${name}":
    ensure     => $ensure,
    base_path  => $base_path,
    repository => Deferred('pulpcore::get_pulp_href_pulpcore_file_file_repository', ["file-mirror-${name}"]),
    *          => $distribution_extra_options,
  }

  if $manage_timer {
    systemd::timer { "sync-file-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {'name' => "file-mirror-${name}", 'service' => "sync-file-mirror-${name}.service", 'on_calendar' => $timer_on_calendar}),
      service_content => epp("${module_name}/mirror/service.epp", {'name' => "file-mirror-${name}", 'plugin' => 'file'}),
    }

    service { "sync-mirror-${name}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["sync-file-mirror-${name}.timer"],
    }
  }

  Pulpcore_file_file_remote["file-mirror-${name}"] 
  -> Pulpcore_file_file_repository["file-mirror-${name}"]
  -> Pulpcore_file_file_distribution["file-mirror-${name}"]
}
