#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_file_file_repository',
  docs: <<-EOS,
@summary Resource for creating pulpcore_file_file_repository

This type provides Puppet with the capabilities to manage a pulp pulpcore_file_file_repository
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
    manifest: {
      type:      'Optional[String]',
      desc:      'Filename to use for manifest file containing metadata for all the files.',
      default:   'PULP_MANIFEST',
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
  },
)
