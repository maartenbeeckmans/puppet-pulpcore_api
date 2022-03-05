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
  Hash             $pulp_labels,
  Boolean          $sync_with_upstream      = true,
) {
  pulpcore_deb_apt_repository { "deb-tree-${title}":
    description => $title,
    pulp_labels => $pulp_labels,
  }

  pulpcore_deb_apt_distribution { "deb-tree-${title}":
    base_path   => "${distribution_prefix}/${split($title, '-')[-1]}",
    repository  => "deb-tree-${title}",
    pulp_labels => $pulp_labels,
  }

  if $upstream and $sync_with_upstream {
    $_copy_template = @(EOT)
    <%- | $plugin, $src_repository_name, $dst_repository_name, $dst_distribution_name | -%>
    /usr/local/bin/sync_repository.sh <%= $plugin %> <%= $src_repository_name %> <%= $dst_repository_name %> <%= $dst_distribution_name %>

    | EOT

    $_copy_config = {
      'plugin'                => 'deb',
      'src_repository_name'   => $upstream,
      'dst_repository_name'   => "deb-tree-${title}",
      'dst_distribution_name' => "deb-tree-${title}",
    }

    concat::fragment { "deb-tree-${title}-upstream":
      target  => $concat_target,
      content => inline_epp($_copy_template, $_copy_config),
      order   => '10',
    }
  }

  Pulpcore_deb_apt_repository["deb-tree-${title}"] -> Pulpcore_deb_apt_distribution["deb-tree-${title}"]
}
