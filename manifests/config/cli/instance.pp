# Manage a pulp cli.toml file for a specific user
#
# @param scheme
#
# @param pulp_host
#
# @param pulp_username
#
# @param pulp_password
#
# @param ssl_verify
#
# @param ssl_cert
#
# @param ssl_key
#
# @param profile
#
# @param format
#
# @param dry_run
#
# @param timeout
#
# @param localuser
#
# @param homedir
#
define pulpcore_api::config::cli::instance (
  Enum['http', 'https']      $scheme,
  String                     $pulp_host,
  String                     $pulp_username,
  String                     $pulp_password,
  Boolean                    $ssl_verify,
  Optional[Stdlib::UnixPath] $ssl_cert  = undef,
  Optional[Stdlib::UnixPath] $ssl_key   = undef,
  Optional[String]           $profile   = undef,
  String                     $format    = 'json',
  Boolean                    $dry_run   = false,
  Integer                    $timeout   = 0,
  String                     $localuser = 'root',
  Optional[String]           $homedir   = undef,
) {
  if $profile {
    $_profile_suffix = "-${profile}"
  } else {
    $_profile_suffix = ''
  }

  if $homedir {
    $_homedir = $homedir
  } else {
    $_homedir = $localuser ? {
      'root'  => '/root',
      default => "/home/${localuser}",
    }
  }

  ensure_resource('exec', "mkdir-${localuser}-config-pulp", {
      command => "/bin/mkdir -p ${_homedir}/.config/pulp",
      creates => "${_homedir}/.config/pulp",
  })

  ensure_resource('concat',"${_homedir}/.config/pulp/cli.toml", {
      ensure  => present,
      require => Exec["mkdir-${localuser}-config-pulp"],
  })

  $_cli_config = @("CLI_CONFIG")
    # This file is managed by puppet - DO NOT EDIT
    [cli${_profile_suffix}]
    base_url = "${scheme}://${pulp_host}"
    username = "${pulp_username}"
    password = "${pulp_password}"
    verify_ssl = ${ssl_verify}
    cert = "${ssl_cert}"
    key = "${ssl_key}"
    format = "${format}"
    dry_run = ${dry_run}
    timeout = ${timeout}
    | CLI_CONFIG

  concat::fragment { "pulp-cli-${title}":
    content => $_cli_config,
    target  => "${_homedir}/.config/pulp/cli.toml",
  }
}
