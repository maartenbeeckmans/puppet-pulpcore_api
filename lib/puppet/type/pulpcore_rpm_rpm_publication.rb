#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_rpm_rpm_publication',
  docs: <<-EOS,
@summary Resource for creating pulpcore_rpm_rpm_publication

This type provides Puppet with the capabilities to manage a pulp pulpcore_rpm_rpm_publication
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    repository_version: {
      type:      'String',
      desc:      'repository_version',
      behaviour: :namevar,
    },
    repository: {
      type:      'String',
      desc:      'A URI of the repository to be published.',
    },
    checksum_type: {
      type:      'Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]',
      # rubocop:disable Layout/LineLength
      desc:      'The preferred checksum type used during repo publishes. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
      # rubocop:enable Layout/LineLength
      default:   'sha512',
    },
    metadata_checksum_type: {
      type:      'Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]',
      desc:      'DEPRECATED: The checksum type for metadata. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
      default:   'sha512',
    },
    package_checksum_type: {
      type:      'Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]',
      desc:      'DEPRECATED: The checksum type for packages. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
      default:   'sha512',
    },
    gpgcheck: {
      type:      'Optional[Integer]',
      desc:      'DEPRECATED: An option specifying whether a client should perform a GPG signature check on packages.',
    },
    repo_gpgcheck: {
      type:      'Optional[Integer]',
      desc:      'DEPRECATED: An option specifying whether a client should perform a GPG signature check on the repodata.',
    },
    repo_config: {
      type:      'Hash',
      desc:      'A JSON document describing config.repo file',
      default:   {},
    },
    compression_type: {
      type:      'Enum[zstd,gz]',
      desc:      'The compression type to use for metadata files. * `zstd` - zstd * `gz` - gz',
      default:   'gz',
    },
    pulp_href: {
      type:      'String',
      desc:      'pulp_href',
      behaviour: :read_only,
    },
    pulp_created: {
      type:      'Runtime',
      desc:      'Timestamp of creation.',
      behaviour: :read_only,
    },
    pulp_last_updated: {
      type:      'Runtime',
      # rubocop:disable Layout/LineLength
      desc:      'Timestamp of the last time this resource was updated. Note: for immutable resources - like content, repository versions, and publication - pulp_created and pulp_last_updated dates will be the same.',
      # rubocop:enable Layout/LineLength
      behaviour: :read_only,
    },
    sqlite_metadata: {
      type:      'Boolean',
      desc:      'REMOVED: An option specifying whether Pulp should generate SQLite metadata. Not operation since pulp_rpm 3.25.0 release',
      default:   false,
      behaviour: :read_only,
    },
  },
)
