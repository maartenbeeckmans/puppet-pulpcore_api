# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   pulpcore_api::tree::deb::step { 'namevar': }
define pulpcore_api::tree::deb::step (
  Hash             $repositories,
  String           $project,
  String           $distribution_prefix,
  Boolean          $first_target            = false,
  Optional[String] $upstream                = undef,
  String           $environment             = $title,
  String           $concat_target           = "/usr/local/bin/promote-deb-${project}-${environment}",
  String           $pulp_server             = $::pulpcore_api::pulp_server,
) {
  $repositories.each |$key, $value| {
    pulpcore_api::tree::deb::step::repo { "${project}-${environment}-${key}":
      upstream            => $first_target ? {
        true    => $value['upstream'],
        default => "${project}-${upstream}-${key}",
      },
      distribution_prefix => "${distribution_prefix}/${project}/${environment}",
      concat_target       => $concat_target,
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

  concat::fragment { "deb-${project}-${environment}-header":
    target  => $concat_target,
    content => inline_epp($_copy_template),
    order   => '01',
  }
}
