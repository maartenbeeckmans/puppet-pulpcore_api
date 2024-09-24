# @summary Install the pulpcore-cli package and configure for this user
#
# Installs the pulpcore-cli package and creates the config file for this user
#
# @example
#   pulpcore_api::config::cli { 'root': }
#
# @param localuser
#   Name of the user where the cli should be installed
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
# @param scheme
#   Scheme of the pulpcore api endpoint
#
# @param ssl_verify
#   Perform an ssl_verify on the pulpcore api configuration
#
# @param ssl_cert
#   SSL client certificate file to use to connect to the pulpcore api
#
# @param ssl_key
#   SSL client certificate key file to use to connect to the pulpcore api
#
# @param cli_packages
#   Name of the cli packages to install
#
# @param cli_packages_ensure
#   Ensure parameter of the cli packages resource
#
define pulpcore_api::config::cli (
  String                     $localuser           = $title,
  String                     $pulp_host           = split($pulpcore_api::pulp_server, '://')[1],
  String                     $pulp_username       = $pulpcore_api::pulp_username,
  String                     $pulp_password       = $pulpcore_api::pulp_password,
  Enum['http', 'https']      $scheme              = split($pulpcore_api::pulp_server, '://')[0],
  Boolean                    $ssl_verify          = $pulpcore_api::ssl_verify,
  Optional[Stdlib::UnixPath] $ssl_cert            = $pulpcore_api::ssl_client_cert,
  Optional[Stdlib::UnixPath] $ssl_key             = $pulpcore_api::ssl_client_key,
  Array[String]              $cli_packages        = $pulpcore_api::cli_packages,
  String                     $cli_packages_ensure = $pulpcore_api::cli_packages_ensure,
) {
  unless $cli_packages == [] {
    ensure_resource('package', $cli_packages, { ensure => $cli_packages_ensure, })
    ensure_resource('file', '/etc/profile.d/pulp.sh', {
        ensure  => file,
        mode    => '0644',
        content => 'eval "$(_PULP_COMPLETE=source_bash pulp)"',
    })
  }

  ensure_resource('pulpcore_api::config::cli::instance', "${localuser}_${pulp_host}", {
      scheme        => $scheme,
      pulp_host     => $pulp_host,
      pulp_username => $pulp_username,
      pulp_password => $pulp_password,
      ssl_verify    => $ssl_verify,
      ssl_cert      => $ssl_cert,
      ssl_key       => $ssl_key,
      localuser     => $localuser,
  })
}
