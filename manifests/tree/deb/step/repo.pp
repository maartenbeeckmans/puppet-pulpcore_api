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
  Boolean          $sync_with_upstream      = true,
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

  if $upstream and $sync_with_upstream {
    $_copy_template = @(EOT)
    <%- | $src_repository_href, $dst_repository_href, $dst_distribution_href | -%>
    /usr/local/bin/sync_repository.sh <%= $src_repository_href %> <%= $dst_repository_href %> <%= $dst_distribution_href %>

    | EOT

    $_copy_config = {
      'src_repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', [$upstream]),
      'dst_repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_repository', [$title]),
      'dst_distribution_href' => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_distribution', [$title]),
    }

    concat::fragment { "deb-${title}-upstream":
      target  => $concat_target,
      content => Deferred('inline_epp', [$_copy_template, $_copy_config]),
      order   => '10',
    }
  }

  Pulpcore_deb_apt_repository[$title] -> Pulpcore_deb_apt_distribution[$title]
}
