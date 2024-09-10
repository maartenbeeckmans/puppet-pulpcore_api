#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_file_file_publication',
  docs: <<-EOS,
@summary Resource for creating pulpcore_file_file_publication

This type provides Puppet with the capabilities to manage a pulp pulpcore_file_file_publication
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
    distributions: {
      type:      'Array',
      desc:      'This publication is currently hosted as defined by these distributions.',
      default:   [],
      behaviour: :read_only,
    },
  },
)
