#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_contentguards_container_content_redirect',
  docs: <<-EOS,
@summary Resource for creating pulpcore_contentguards_container_content_redirect

This type provides Puppet with the capabilities to manage a pulp pulpcore_contentguards_container_content_redirect
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
      desc:      'The unique name.',
      behaviour: :namevar,
    },
    description: {
      type:      'Optional[String]',
      desc:      'An optional description.',
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
