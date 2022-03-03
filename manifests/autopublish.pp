#
#
#
class pulpcore_api::autopublish {
    file { '/usr/local/bin/publish_new_deb_repositories.sh':
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/pulpcore_api/deb/publish_new_repositories.sh',
    }
    file { '/usr/local/bin/publish_new_rpm_repositories.sh':
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/pulpcore_api/rpm/publish_new_repositories.sh',
    }

    exec { 'autopublish new deb repositories':
      command     => '/usr/local/bin/publish_new_deb_repositories.sh',
      user        => 'root',
      refreshonly => true,
      provider    => 'shell',
      logoutput   => 'on_failure',
    }
    exec { 'autopublish new rpm repositories':
      command     => '/usr/local/bin/publish_new_rpm_repositories.sh',
      user        => 'root',
      refreshonly => true,
      provider    => 'shell',
      logoutput   => 'on_failure',
    }

    Pulpcore_deb_apt_distribution <| |> ~> Exec['autopublish new deb repositories']
    Pulpcore_rpm_rpm_distribution <| |> ~> Exec['autopublish new rpm repositories']
}
