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
# @param scheme
#   Scheme of the pulpcore api endpoint
#
# @param ssl_verify
#   Perform an ssl_verify on the pulpcore api configuration
#
# @param cli_packages
#   Name of the cli packages to install
#
# @param cli_packages_ensure
#   Ensure parameter of the cli packages resource
#
define pulpcore_api::config::cli (
  String                $localuser           = $title,
  Optional[String]      $homedir             = undef,
  String                $pulp_host           = split($::pulpcore_api::pulp_server, '://')[1],
  String                $pulp_username       = $::pulpcore_api::pulp_username,
  String                $pulp_password       = $::pulpcore_api::pulp_password,
  Enum['http', 'https'] $scheme              = split($::pulpcore_api::pulp_server, '://')[0],
  Boolean               $ssl_verify          = $::pulpcore_api::ssl_verify,
  Array[String]         $cli_packages        = $::pulpcore_api::cli_packages,
  String                $cli_packages_ensure = $::pulpcore_api::cli_packages_ensure,
) {
  if $cli_packages != [] {
    ensure_resource('package', $cli_packages, { ensure => $cli_packages_ensure, })
    ensure_resource('file', '/etc/profile.d/pulp.sh', {
      ensure  => file,
      mode    => '0644',
      content => 'eval "$(_PULP_COMPLETE=source_bash pulp)"',
    })
  }

  if $homedir {
    $_homedir = $homedir
  } else {
    $_homedir = $localuser ? {
      'root'  => '/root',
      default => "/home/${localuser}",
    }
  }

  exec{ "mkdir-${localuser}-config-pulp":
    command => "/bin/mkdir -p ${_homedir}/.config/pulp",
    creates => "${_homedir}/.config/pulp",
  }

  $cli_config = @("CLI_CONFIG")
    # This file is managed by puppet - DO NOT EDIT
    [cli]
    base_url = "${scheme}://${pulp_host}"
    username = "${pulp_username}"
    password = "${pulp_password}"
    verify_ssl = ${ssl_verify}
    format = "json"
    dry_run = false
    timeout = 0
    | CLI_CONFIG

  file{ "${_homedir}/.config/pulp/cli.toml":
    ensure  => file,
    content => $cli_config,
    mode    => '0640',
    require => Exec["mkdir-${localuser}-config-pulp"],
  }
}
