# @summary Install pulpcore_api configuration
#
# @example
#   include pulpcore_api::config
class pulpcore_api::config (
  Boolean $manage_api_config = $::pulpcore_api::manage_api_config,
  Hash    $cli_users         = $::pulpcore_api::cli_users,
  Hash    $netrc_users       = $::pulpcore_api::netrc_users,
) {
  if $manage_api_config {
    include pulpcore_api::config::pulpcore_api
  }
  create_resources('pulpcore_api::config::cli', $cli_users)
  create_resources('pulpcore_api::config::netrc', $netrc_users)
}
