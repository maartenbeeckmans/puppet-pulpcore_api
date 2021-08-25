# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_deb_apt_distribution',
  docs: <<-EOS,
@summary Resource for creating pulpcore_deb_apt_distribution

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
      desc:      'A unique name. Ex, `rawhide` and `stable`.',
      behaviour: :namevar,
    },
    
    base_path: {
      type:      'String',
      desc:      'The base (relative) path component of the published url. Avoid paths that overlap with other distribution base paths (e.g. "foo" and "foo/bar")',
    },
    
    content_guard: {
      type:      'Optional[String]',
      desc:      'An optional content-guard.',
    },
    
    pulp_labels: {
      type:      'Hash',
      desc:      'pulp_labels',
      default:   {},
    },
    
    repository: {
      type:      'Optional[String]',
      desc:      'The latest RepositoryVersion for this Repository will be served.',
    },
    
    publication: {
      type:      'Optional[String]',
      desc:      'Publication to be served',
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
    
    base_url: {
      type:      'String',
      desc:      'The URL for accessing the publication as defined by this distribution.',
      behaviour: :read_only,
    },
    
  },
)
