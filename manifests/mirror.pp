#
#
#
class pulpcore_api::mirror {
  if $::pulpcore_api::container_container_mirrors {
    create_resources(
      pulpcore_api::mirror::container,
      $::pulpcore_api::container_container_mirrors,
      $::pulpcore_api::container_container_mirror_defaults
    )
  }

  if $::pulpcore_api::deb_apt_mirrors {
    create_resources(
      pulpcore_api::mirror::deb,
      $::pulpcore_api::deb_apt_mirrors,
      $::pulpcore_api::deb_apt_mirror_defaults
    )
  }

  if $::pulpcore_api::file_file_mirrors {
    create_resources(
      pulpcore_api::mirror::file,
      $::pulpcore_api::file_file_mirrors,
      $::pulpcore_api::file_file_mirror_defaults
    )
  }

  if $::pulpcore_api::rpm_rpm_mirrors {
    create_resources(
      pulpcore_api::mirror::rpm,
      $::pulpcore_api::rpm_rpm_mirrors,
      $::pulpcore_api::rpm_rpm_mirror_defaults
    )
  }
}
