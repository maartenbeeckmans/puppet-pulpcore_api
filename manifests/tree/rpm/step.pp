#
#
#
define pulpcore_api::tree::rpm::step (
  Hash             $repositories,
  String           $project,
  String           $releasever,
  String           $basearch,
  String           $distribution_prefix,
  Boolean          $first_target            = false,
  Optional[String] $upstream                = undef,
  Integer          $retain_package_versions = 0,
  String           $environment             = $title,
  String           $concat_target           = "/usr/local/bin/promote-rpm-${project}-${environment}",
  String           $pulp_server             = $::pulpcore_api::pulp_server,
) {
  $repositories.each |$key, $value| {
    pulpcore_api::tree::rpm::step::repo { "${project}-${environment}-${releasever}-${basearch}-${key}":
      upstream                => $first_target ? {
        true    => $value['upstream'],
        default => "${project}-${upstream}-${releasever}-${basearch}-${key}",
      },
      distribution_prefix     => "${distribution_prefix}/${project}/${environment}/${releasever}/${basearch}",
      retain_package_versions => $retain_package_versions,
      concat_target           => $concat_target,
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

  concat::fragment { "rpm-${project}-${environment}-header":
    target  => $concat_target,
    content => inline_epp($_copy_template),
    order   => '01',
  }
}
