#
#
#
class pulpcore_api (
  Boolean       $manage_agent_gems,
  Array[String] $agent_gems,
) {
  if $manage_agent_gems {
    package { $agent_gems:
      ensure   => installed,
      provider => 'puppet_gem',
    }
  }

  pulpcore_file_repository { 'test':
    retained_versions => 1,
  }
}
