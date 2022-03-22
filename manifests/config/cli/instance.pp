#
#
#
define pulpcore_api::config::cli::instance (
  Enum['http', 'https'] $scheme,
  String                $pulp_host,
  String                $pulp_username,
  String                $pulp_password,
  Boolean               $ssl_verify,
  Optional[String]      $profile       = undef,
  String                $format        = 'json',
  Boolean               $dry_run       = false,
  Integer               $timeout       = 0,
  String                $localuser     = 'root',
  Optional[String]      $homedir       = undef,
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
    format = "${format}"
    dry_run = ${dry_run}
    timeout = ${timeout}
    | CLI_CONFIG

  concat::fragment { $title:
    content => $_cli_config,
    target  => "${_homedir}/.config/pulp/cli.toml",
  }
}
