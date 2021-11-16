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
) {
  # Create remote
  pulpcore_deb_apt_remote { "mirror-${name}":
    ensure         => $ensure,
    url            => $url,
    policy         => $policy,
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

  $_sync_template = @(EOT)
<%- | $remote_href, $repository_href, $distribution_href | -%>
#!/bin/bash
/usr/local/bin/sync_mirror.sh <%= $remote_href %> <%= $repository_href %> <%= $distribution_href %>
  EOT
  $_sync_config = {
    'remote_href'       => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_remote', ["mirror-${name}"]),
    'repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', ["mirror-${name}"]),
    'distribution_href' => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_distribution', ["mirror-${name}"]),
  }

  file { "/usr/local/bin/sync_deb_mirror_${name}":
    ensure  => 'present',
    content => Deferred('inline_epp', [$_sync_template, $_sync_config]),
    mode    => '0755',
  }

  if $manage_timer {
    systemd::timer { "sync-mirror-${name}.timer":
      timer_content   => epp("${module_name}/mirror/timer.epp", {
        'name'        => "mirror-${name}",
        'service'     => "sync-mirror-${name}.service",
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/mirror/service_deb.epp", {
        'name'   => $name,
        'plugin' => 'deb'
      }),
    }

    service { "sync-mirror-${name}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["sync-mirror-${name}.timer"],
    }
  }
}
