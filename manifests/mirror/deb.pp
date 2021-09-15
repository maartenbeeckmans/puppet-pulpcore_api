#
#
#
define pulpcore_api::mirror::deb (
  Stdlib::HTTPUrl       $url,
  String                $base_path,
  String                $distributions,
  String                $components,
  String                $architectures,
  Boolean               $sync_sources               = false,
  Boolean               $sync_udebs                 = false,
  Boolean               $sync_installer             = false,
  Enum[present, absent] $ensure                     = 'present',
  String                $policy                     = 'immediate',
  Boolean               $manage_timer               = true,
  Boolean               $mirror                     = true,
  Hash                  $remote_extra_options       = {},
  Hash                  $repository_extra_options   = {},
  Hash                  $distribution_extra_options = {},
) {
  # Create remote
  pulpcore_deb_apt_remote { "mirror-${name}":
    ensure         => $ensure,
    url            => $url,
    distributions  => $distributions,
    components     => $components,
    architectures  => $architectures,
    sync_sources   => $sync_sources,
    sync_udebs     => $sync_udebs,
    sync_installer => $sync_installer,
    *              => $remote_extra_options,
  }

  # Create repository
  pulpcore_deb_apt_repository { "mirror-${name}":
    ensure      => $ensure,
    remote      => Deferred('pulpcore::get_pulp_href_pulpcore_deb_apt_remote', ["mirror-${name}"]),
    *           => $repository_extra_options,
  }

  # Create distribution
  pulpcore_deb_apt_distribution { "mirror-${name}":
    ensure     => $ensure,
    base_path  => $base_path,
    *          => $distribution_extra_options,
  }
}
