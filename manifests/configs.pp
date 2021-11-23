class pulpcore_api::configs (
  String $pulp_host = split($::pulpcore_api::pulp_server, '://')[1],
  String $pulp_username = $::pulpcore_api::pulp_username,
  String $pulp_password = $::pulpcore_api::pulp_password,
  Enum['http', 'https'] $scheme = split($::pulpcore_api::pulp_server, '://')[0],
  Boolean $ssl_verify = $::pulpcore_api::ssl_verify,
  Boolean $manage_api_config = $::pulpcore_api::manage_api_config,
  Boolean $manage_cli_config = $::pulpcore_api::manage_cli_config,
  String $cli_package = $::pulpcore_api::cli_package,
  String $cli_package_ensure = $::pulpcore_api::cli_package_ensure,
) {

  if $manage_api_config {
    file{ '/etc/puppetlabs/puppet/pulpcoreapi.yaml':
      ensure  => file,
      content => to_yaml({
        host       => $pulp_host,
        username   => $pulp_username,
        password   => $pulp_password,
        scheme     => $scheme,
        ssl_verify => $ssl_verify,
      }),
    }
  }

  if $cli_package {
    package{ $cli_package:
      ensure => $cli_package_ensure,
    }
  }


  if $manage_cli_config {

    exec{ 'mkdir-root-config-pulp':
      command => '/bin/mkdir -p /root/.config/pulp',
      creates => '/root/.config/pulp',
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

    file{ '/root/.config/pulp/cli.toml':
      ensure  => file,
      content => $cli_config,
      require => Exec['mkdir-root-config-pulp'],
    }

  }

}
