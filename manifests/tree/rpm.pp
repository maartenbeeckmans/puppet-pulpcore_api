#
#
#
define pulpcore_api::tree::rpm (
  Hash   $targets,
  Hash   $repositories,
  String $releasever          = '8',
  String $basearch            = 'x86_64',
  String $project             = $title,
  String $distribution_prefix = 'rpm/private/tree',
) {
  create_resources ( 'pulpcore_api::tree::rpm::step',
    $targets,
    {
      repositories        => $repositories,
      project             => $project,
      releasever          => $releasever,
      basearch            => $basearch,
      distribution_prefix => $distribution_prefix,
    }
  )

  ensure_resource ( 'file', '/usr/local/bin/sync_repository.sh', {
    ensure  => 'present',
    content => epp("${module_name}/sync_repository.sh.epp", {'pulp_server' => $::pulpcore_api::pulp_server}),
    mode    => '0755',
  })
}
