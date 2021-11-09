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
  String           $concat_target           = "/usr/local/bin/promote-${project}-${environment}",
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
  <%- | String $pulp_server, | -%>
  #!/bin/bash
  #
  # File managed by Puppet
  # All manual changes will be overwritten
  #
  set -ex

  pulp_server=<%= $pulp_server %>

  function wait_until_finished {
    local task=${1}
    echo "Waiting until ${task} is finished"
    while true
    do
      local state=$(curl --netrc -s -H "Content-Type: application/json" "${pulp_server}${task}" | jq -r '.state')
      case ${state} in
        failed|canceled)
          echo "Task in final state: ${state}"
          exit 1
          ;;
        completed)
          echo "Task finished"
          created_resource=$(curl --netrc -s -H "Content-Type: application/json" "${pulp_server}${task}" | jq -r '.created_resources|.[0]')
          break
          ;;
        *)
          echo "Still waiting..."
          sleep 1
          ;;
      esac
    done
  }
  | EOT

  concat::fragment { "${project}-${environment}-header":
    target  => $concat_target,
    content => inline_epp($_copy_template, {'pulp_server' => $pulp_server}),
    order   => '01',
  }
}
