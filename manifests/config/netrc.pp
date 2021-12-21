# @summary Configure netrc for the user
#
# Configure netrc for the user so it can connect to the pulpcore api
#
# @example
#   pulpcore_api::config::netrc { 'root': }
#
# @param localuser
#   Name of the user where the cli should be installed
#
# @param homedir
#   Homedir of the user, can be used to overwrite the default
#
# @param pulp_host
#   Hostname used to connect to the pulpcore api
#
# @param pulp_username
#   Username used to connect to the pulpcore api
#
# @param pulp_password
#   Password used to connect to the pulpcore api
#
define pulpcore_api::config::netrc (
  String           $localuser          = $title,
  Optional[String] $homedir            = undef,
  String           $pulp_host          = split($::pulpcore_api::pulp_server, '://')[1],
  String           $pulp_username      = $::pulpcore_api::pulp_username,
  String           $pulp_password      = $::pulpcore_api::pulp_password,
) {

  if $homedir {
    $_homedir = $homedir
  } else {
    $_homedir = $localuser ? {
      'root'  => '/root',
      default => "/home/${localuser}",
    }
  }

  $netrc = @("NETRC")
    # This file is managed by puppet - DO NOT EDIT
    machine ${pulp_host}
    login ${pulp_username}
    password ${pulp_password}
    | NETRC

  file{ "${_homedir}/.netrc":
    ensure  => file,
    content => $netrc,
    mode    => '0640',
  }
}
