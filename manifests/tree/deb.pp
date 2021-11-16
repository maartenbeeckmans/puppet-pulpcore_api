# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   pulpcore_api::tree::deb { 'namevar': }
define pulpcore_api::tree::deb (
  Hash   $targets,
  Hash   $repositories,
  String $project             = $title,
  String $distribution_prefix = 'deb/private/tree',
) {
  create_resources ( 'pulpcore_api::tree::deb::step',
    $targets,
    {
      repositories        => $repositories,
      project             => $project,
      distribution_prefix => $distribution_prefix,
    }
  )
}
