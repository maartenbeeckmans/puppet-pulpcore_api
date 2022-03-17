#
#
#
class pulpcore_api::promotion_tree {
  if $::pulpcore_api::deb_apt_promotion_trees {
    create_resources(
      pulpcore_api::promotion_tree::deb,
      $::pulpcore_api::deb_apt_promotion_trees,
      $::pulpcore_api::deb_apt_promotion_tree_defaults
    )
  }

  if $::pulpcore_api::rpm_rpm_promotion_trees {
    create_resources(
      pulpcore_api::promotion_tree::rpm,
      $::pulpcore_api::rpm_rpm_promotion_trees,
      $::pulpcore_api::rpm_rpm_promotion_tree_defaults
    )
  }
}
