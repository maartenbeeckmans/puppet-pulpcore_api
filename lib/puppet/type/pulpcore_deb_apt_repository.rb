# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_deb_apt_repository',
  docs: <<-EOS,
@summary Resource for creating pulpcore_deb_apt_repository

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
      default:   '{}',
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
