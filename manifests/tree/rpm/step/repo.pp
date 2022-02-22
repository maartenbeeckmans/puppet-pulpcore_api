#
#
#
define pulpcore_api::tree::rpm::step::repo (
  String           $distribution_prefix,
  Integer          $retain_package_versions,
  String           $concat_target,
  Optional[String] $upstream,
  Boolean          $sync_with_upstream      = true,
) {
  pulpcore_rpm_rpm_repository { "rpm-tree-${title}":
    description             => $title,
    autopublish             => true,
    retain_package_versions => $retain_package_versions,
  }

  pulpcore_rpm_rpm_distribution { "rpm-tree-${title}":
    base_path  => "${distribution_prefix}/${split($title, '-')[-1]}",
    repository => "rpm-tree-${title}",
  }

  if $upstream and $sync_with_upstream {
    $_copy_template = @(EOT)
    <%- | $plugin, $src_repository_name, $dst_repository_name, $dst_distribution_name | -%>
    /usr/local/bin/sync_repository.sh <%= $plugin %> <%= $src_repository_name %> <%= $dst_repository_name %> <%= $dst_distribution_name %>

    | EOT
    $_copy_config = {
      'plugin'                => 'rpm',
      'src_repository_name'   => $upstream,
      'dst_repository_name'   => "rpm-tree-${title}",
      'dst_distribution_name' => "rpm-tree-${title}",
    }

    concat::fragment { "rpm-tree-${title}-upstream":
      target  => $concat_target,
      content => inline_epp($_copy_template, $_copy_config),
      order   => '10',
    }
  }

  Pulpcore_rpm_rpm_repository["rpm-tree-${title}"] -> Pulpcore_rpm_rpm_distribution["rpm-tree-${title}"]
}
