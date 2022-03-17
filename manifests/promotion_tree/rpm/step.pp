#
#
#
define pulpcore_api::promotion_tree::rpm::step (
  Hash             $repositories,
  String           $project,
  String           $releasever,
  String           $basearch,
  String           $distribution_prefix,
  Boolean          $first_target            = false,
  Optional[String] $upstream                = undef,
  Integer          $retain_package_versions = 0,
  String           $environment             = regsubst($title, "${project}-", ''),
  String           $concat_target           = "/usr/local/bin/promote-rpm-tree-${project}-${environment}",
  String           $pulp_server             = $::pulpcore_api::pulp_server,
  Boolean          $manage_timer            = true,
  String           $timer_on_calendar       = 'daily',
) {
  $repositories.each |$key, $value| {
    pulpcore_api::promotion_tree::rpm::step::repo { "${project}-${environment}-${releasever}-${basearch}-${key}":
      upstream                => $first_target ? { #lint:ignore:selector_inside_resource
        true    => $value['upstream'],
        default => "rpm-tree-${project}-${upstream}-${releasever}-${basearch}-${key}",
      },
      sync_with_upstream      => $value['sync_with_upstream'] ? { #lint:ignore:selector_inside_resource
        true    => true,
        false   => false,
        default => true,
      },
      distribution_prefix     => "${distribution_prefix}/${project}/${environment}/${releasever}/${basearch}",
      retain_package_versions => $retain_package_versions,
      concat_target           => $concat_target,
      pulp_labels             => {
        'type'        => 'tree',
        'project'     => $project,
        'environment' => $environment,
        'repository'  => $key,
        'releasever'  => $releasever,
        'basearch'    => $basearch,
      },
    }
  }

  concat { $concat_target:
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  $_copy_template = @(EOT)
  #!/bin/bash
  #
  # File managed by Puppet
  # All manual changes will be overwritten
  #
  set -e

  | EOT

  concat::fragment { "rpm-tree-${project}-${environment}-header":
    target  => $concat_target,
    content => inline_epp($_copy_template),
    order   => '01',
  }

  if $manage_timer {
    systemd::timer { "promote-rpm-tree-${project}-${environment}.timer":
      timer_content   => epp("${module_name}/tree/timer.epp", {
        'name'        => "promote-rpm-tree-${project}-${environment}",
        'service'     => "promote-rpm-tree-${project}-${environment}.service",
        'on_calendar' => $timer_on_calendar,
      }),
      service_content => epp("${module_name}/tree/service.epp", {
        'name'        => "rpm tree ${project} ${environment}",
        'script_path' => $concat_target,
      }),
    }

    service { "promote-rpm-tree-${project}-${environment}.timer":
      ensure    => running,
      subscribe => Systemd::Timer["promote-rpm-tree-${project}-${environment}.timer"],
    }
  }
}
