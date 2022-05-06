#
#
#
define pulpcore_api::config::netrc::instance (
  String           $pulp_host,
  String           $pulp_username,
  String           $pulp_password,
  String           $localuser          = 'root',
  Optional[String] $homedir            = undef,
) {
  if $homedir {
    $_homedir = $homedir
  } else {
    $_homedir = $localuser ? {
      'root'  => '/root',
      default => "/home/${localuser}",
    }
  }

  ensure_resource('concat',"${_homedir}/.netrc", {
    ensure  => present,
  })

  $netrc = @("NETRC")
    # This file is managed by puppet - DO NOT EDIT
    machine ${pulp_host}
    login ${pulp_username}
    password ${pulp_password}
    | NETRC

  concat::fragment { "pulp-netrc-${title}":
    content => $netrc,
    target  => "${_homedir}/.netrc",
  }
}
