#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_rpm_rpm_repository',
  docs: <<-EOS,
@summary Resource for creating pulpcore_rpm_rpm_repository

This type provides Puppet with the capabilities to manage a pulp pulpcore_rpm_rpm_repository
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present, absent]',
      desc:    'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'A unique name for this repository.',
      behaviour: :namevar,
    },
    pulp_labels: {
      type:      'Hash',
      desc:      'pulp_labels',
      default:   {},
    },
    description: {
      type:      'Optional[String]',
      desc:      'An optional description.',
    },
    retain_repo_versions: {
      type:      'Optional[Integer]',
      desc:      'Retain X versions of the repository. Default is null which retains all versions.',
    },
    remote: {
      type:      'Optional[String]',
      desc:      'An optional remote to use by default when syncing.',
    },
    autopublish: {
      type:      'Boolean',
      desc:      'Whether to automatically create publications for new repository versions, and update any distributions pointing to this repository.',
      default:   false,
    },
    metadata_signing_service: {
      type:      'Optional[String]',
      desc:      'A reference to an associated signing service.',
    },
    retain_package_versions: {
      type:      'Integer',
      # rubocop:disable Layout/LineLength
      desc:      'The number of versions of each package to keep in the repository; older versions will be purged. The default is `0`, which will disable this feature and keep all versions of each package.',
      # rubocop:enable Layout/LineLength
      default:   0,
    },
    checksum_type: {
      type:      'Optional[Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]]',
      # rubocop:disable Layout/LineLength
      desc:      'The preferred checksum type during repo publish. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
      # rubocop:enable Layout/LineLength
    },
    metadata_checksum_type: {
      type:      'Optional[Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]]',
      desc:      'DEPRECATED: use CHECKSUM_TYPE instead. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
    },
    package_checksum_type: {
      type:      'Optional[Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]]',
      desc:      'DEPRECATED: use CHECKSUM_TYPE instead. * `unknown` - unknown * `md5` - md5 * `sha1` - sha1 * `sha224` - sha224 * `sha256` - sha256 * `sha384` - sha384 * `sha512` - sha512',
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
      type:      'Optional[Enum[zstd,gz]]',
      desc:      'The compression type to use for metadata files. * `zstd` - zstd * `gz` - gz',
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
    versions_href: {
      type:      'String',
      desc:      'versions_href',
      behaviour: :read_only,
    },
    latest_version_href: {
      type:      'String',
      desc:      'latest_version_href',
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
