# @summary Manage pulpcore_api configuration
#
# @example
#   include pulpcore_api::config::pulpcore_api
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
class pulpcore_api::config::pulpcore_api (
  String                $pulp_host     = split($::pulpcore_api::pulp_server, '://')[1],
  String                $pulp_username = $::pulpcore_api::pulp_username,
  String                $pulp_password = $::pulpcore_api::pulp_password,
  Enum['http', 'https'] $scheme        = split($::pulpcore_api::pulp_server, '://')[0],
  Boolean               $ssl_verify    = $::pulpcore_api::ssl_verify,
) {
  file{ '/etc/puppetlabs/puppet/pulpcoreapi.yaml':
    ensure  => file,
    content => to_yaml({
      host       => $pulp_host,
      username   => $pulp_username,
      password   => $pulp_password,
      scheme     => $scheme,
      ssl_verify => $ssl_verify,
    }),
    mode    => '0640',
  }
}
