# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   pulpcore_api::promotion_tree::deb { 'namevar': }
define pulpcore_api::promotion_tree::deb (
  Hash   $targets,
  Hash   $repositories,
  String $project             = $title,
  String $distribution_prefix = 'deb/private/tree',
) {
  create_resources ( 'pulpcore_api::promotion_tree::deb::step',
    prefix($targets, "${project}-"),
    {
      repositories        => $repositories,
      project             => $project,
      distribution_prefix => $distribution_prefix,
    }
  )

  ensure_resource ( 'file', '/usr/local/bin/sync_repository.sh', {
    ensure  => 'present',
    content => epp("${module_name}/sync_repository.sh.epp", {'pulp_server' => $::pulpcore_api::pulp_server}),
    mode    => '0755',
  })
}
