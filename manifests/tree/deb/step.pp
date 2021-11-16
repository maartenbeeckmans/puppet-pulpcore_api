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
  Integer          $retain_package_versions = 0,
  String           $environment             = $title,
  String           $concat_target           = "/usr/local/bin/promote-deb-${project}-${environment}",
  String           $pulp_server             = $::pulpcore_api::pulp_server,
) {
  $repositories.each |$key, $value| {
    pulpcore_api::tree::deb::step::repo { "${project}-${environment}-${key}":
      upstream                => $first_target ? {
        true    => $value['upstream'],
        default => "${project}-${upstream}-${key}",
      },
      distribution_prefix     => "${distribution_prefix}/${project}/${environment}",
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
  <%- | String $pulp_server, | -%>
  #!/bin/bash
  #
  # File managed by Puppet
  # All manual changes will be overwritten
  #
  set -ex

  pulp_server=<%= $pulp_server %>

  | EOT

  concat::fragment { "deb-${project}-${environment}-header":
    target  => $concat_target,
    content => inline_epp($_copy_template, {'pulp_server' => $pulp_server}),
    order   => '01',
  }
}