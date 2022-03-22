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
  String           $pulp_host          = split($::pulpcore_api::pulp_server, '://')[1],
  String           $pulp_username      = $::pulpcore_api::pulp_username,
  String           $pulp_password      = $::pulpcore_api::pulp_password,
) {
  ensure_resource('pulpcore_api::config::netrc::instance', "${localuser}_${pulp_host}", {
    localuser     => $localuser,
    pulp_host     => $pulp_host,
    pulp_username => $pulp_username,
    pulp_password => $pulp_password,
  })
}
