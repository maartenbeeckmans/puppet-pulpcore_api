# Valid RPM sync policies
type Pulpcore_api::Rpm_sync_policy = Enum[
  'additive',
  'mirror_complete',
  'mirror_content_only',
]
