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
    metadata_checksum_type: {
      type:      'Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]',
      desc:      'The checksum type for metadata.',
      default:   'sha512',
    },
    package_checksum_type: {
      type:      'Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]',
      desc:      'The checksum type for packages.',
      default:   'sha512',
    },
    gpgcheck: {
      type:      'Integer',
      desc:      'An option specifying whether a client should perform a GPG signature check on packages.',
      default:   0,
    },
    repo_gpgcheck: {
      type:      'Integer',
      desc:      'An option specifying whether a client should perform a GPG signature check on the repodata.',
      default:   0,
    },
    sqlite_metadata: {
      type:      'Boolean',
      desc:      'An option specifying whether Pulp should generate SQLite metadata.',
      default:   false,
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
  },
)
