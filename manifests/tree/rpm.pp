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
}
