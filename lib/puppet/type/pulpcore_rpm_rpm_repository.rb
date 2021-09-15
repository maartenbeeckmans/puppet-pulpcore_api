# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_rpm_rpm_repository',
  docs: <<-EOS,
@summary Resource for creating pulpcore_rpm_rpm_repository

This type provides Puppet with the capabilities to manage a pulp 
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
    
    retained_versions: {
      type:      'Optional[Integer]',
      desc:      'Retain X versions of the repository. Default is null which retains all versions. This is provided as a tech preview in Pulp 3 and may change in the future.',
    },
    
    remote: {
      type:      'Optional[String]',
      desc:      'remote',
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
      desc:      'The number of versions of each package to keep in the repository; older versions will be purged. The default is `0`, which will disable this feature and keep all versions of each package.',
      default:   0,
    },
    
    metadata_checksum_type: {
      type:      'Optional[Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]]',
      desc:      'The checksum type for metadata.',
    },
    
    package_checksum_type: {
      type:      'Optional[Enum[unknown,md5,sha1,sha224,sha256,sha384,sha512]]',
      desc:      'The checksum type for packages.',
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
    
  },
)
