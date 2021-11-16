# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   pulpcore_api::tree::deb::step::repo { 'namevar': }
define pulpcore_api::tree::deb::step::repo (
  String           $distribution_prefix,
  String           $concat_target,
  Optional[String] $upstream,
) {
  ensure_resource ( 'pulpcore_deb_apt_repository',
    $title,
    {
      description             => $title,
    }
  )

  ensure_resource ( 'pulpcore_deb_apt_distribution',
    $title,
    {
      base_path  => "${distribution_prefix}/${split($title, '-')[-1]}",
      repository => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', [$title]),
    }
  )

  if $upstream {
    $_copy_template = @(EOT)
    <%- | $repo_name, $upstream_name, $repo_href, $upstream_href | -%>
    echo 'Syncing <%= $repo_name %> from <%= $upstream_name %>'
    echo 'Syncing <%= $repo_href %> from <%= $upstream_href %>'
    latest_version_href=$(curl --netrc -k -s -H "Content-Type: application/json" "http://${pulp_server}<%= $upstream_href -%>" | jq .latest_version_href)"
    task_href=$(curl --netrc -k -s "Content-Type: application/json" "http://${pulp_server}<%= $upstream_href -%>modify/ -d \"{\"base_version\": [ \"${latest_version_href}\" ] }\"")
    /bin/pulp task show --wait --href ${task_href//'"'/''}

    | EOT
    $_copy_config = {
      'repo_name'     => $title,
      'upstream_name' => $upstream,
      'repo_href'     => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', [$title]),
      'upstream_href' => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', [$upstream])
    }

    concat::fragment { "deb-${title}-upstream":
      target  => $concat_target,
      content => Deferred('inline_epp', [$_copy_template, $_copy_config]),
      order   => '10',
    }
  }

  Pulpcore_deb_apt_repository[$title] -> Pulpcore_deb_apt_distribution[$title]
}
