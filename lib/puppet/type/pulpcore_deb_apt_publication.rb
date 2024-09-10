#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_deb_apt_publication',
  docs: <<-EOS,
@summary Resource for creating pulpcore_deb_apt_publication

This type provides Puppet with the capabilities to manage a pulp pulpcore_deb_apt_publication
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
    simple: {
      type:      'Boolean',
      desc:      'Activate simple publishing mode (all packages in one release component).',
      default:   false,
    },
    structured: {
      type:      'Boolean',
      desc:      'Activate structured publishing mode.',
      default:   true,
    },
    signing_service: {
      type:      'String',
      desc:      'Sign Release files with this signing key',
    },
    publish_upstream_release_fields: {
      type:      'Boolean',
      desc:      'publish_upstream_release_fields',
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
    pulp_last_updated: {
      type:      'Runtime',
      # rubocop:disable Layout/LineLength
      desc:      'Timestamp of the last time this resource was updated. Note: for immutable resources - like content, repository versions, and publication - pulp_created and pulp_last_updated dates will be the same.',
      # rubocop:enable Layout/LineLength
      behaviour: :read_only,
    },
  },
)
