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
      autopublish             => true,
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
    <%- | $src_repository_href, $dst_repository_href, $dst_distribution_href | -%>
    /usr/local/bin/sync_repository.sh <%= $src_repository_href %> <%= $dst_repository_href %> <%= $dst_distribution_href %>

    | EOT
    $_copy_config = {
      'src_repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', [$upstream]),
      'dst_repository_href'   => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_repository', [$title]),
      'dst_distribution_href' => Deferred('pulpcore::get_pulp_href_pulpcore_rpm_rpm_distribution', [$title]),
    }

    concat::fragment { "rpm-${title}-upstream":
      target  => $concat_target,
      content => Deferred('inline_epp', [$_copy_template, $_copy_config]),
      order   => '10',
    }
  }

  Pulpcore_rpm_rpm_repository[$title] -> Pulpcore_rpm_rpm_distribution[$title]
}
