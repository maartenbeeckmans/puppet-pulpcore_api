#
#
#
define pulpcore_api::tree::rpm::step::repo (
  String           $distribution_prefix,
  Integer          $retain_package_versions,
  String           $concat_target,
  Optional[String] $upstream,
) {
  ensure_resource ( 'pulpcore_rpm_rpm_repository',
    $title,
    {
      description             => $title,
      autopublish             => $true,
      retain_package_versions => $retain_package_versions,
    }
  )

  ensure_resource ( 'pulpcore_rpm_rpm_distribution',
    $title,
    {
      base_path  => "${distribution_prefix}/${split($title, '-')[-1]}",
      repository => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', [$title]),
    }
  )

  if $upstream {
    $_copy_template = @(EOT)
    <%- | $repo_name, $upstream_name, $repo_href, $upstream_href | -%>
    echo 'Syncing <%= $repo_name %> from <%= $upstream_name %>'
    echo 'Syncing <%= $repo_href %> from <%= $upstream_href %>'
    latest_version_href=$(curl --netrc -k -s -H "Content-Type: application/json" "http://${pulp_server}:${pulp_port}<%= $upstream_href -%>" | jq .latest_version_href)"
    task_href=$(curl --netrc -k -s "Content-Type: application/json" "http://${pulp_server}:${pulp_port}<%= $upstream_href -%>modify/ -d \"{\"base_version\": [ \"${latest_version_href}\" ] }\"")

    | EOT
    $_copy_config = {
      'repo_name'     => $title,
      'upstream_name' => $upstream,
      'repo_href'     => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', [$title]),
      'upstream_href' => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', [$upstream])
    }

    concat::fragment { "${title}-upstream":
      target  => $concat_target,
      content => Deferred('inline_epp', [$_copy_template, $_copy_config]),
      order   => '10',
    }
  }

  Pulpcore_rpm_rpm_repository[$title] -> Pulpcore_rpm_rpm_distribution[$title]
}
