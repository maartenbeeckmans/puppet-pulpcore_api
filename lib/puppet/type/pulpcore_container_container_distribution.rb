# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_container_container_distribution',
  docs: <<-EOS,
@summary Resource for creating pulpcore_container_container_distribution

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
    
    repository: {
      type:      'Optional[String]',
      desc:      'The latest RepositoryVersion for this Repository will be served.',
    },
    
    pulp_labels: {
      type:      'Hash',
      desc:      'pulp_labels',
      default:   {},
    },
    
    base_path: {
      type:      'String',
      desc:      'The base (relative) path component of the published url. Avoid paths that overlap with other distribution base paths (e.g. "foo" and "foo/bar")',
    },
    
    content_guard: {
      type:      'Optional[String]',
      desc:      'An optional content-guard. If none is specified, a default one will be used.',
    },
    
    repository_version: {
      type:      'Optional[String]',
      desc:      'RepositoryVersion to be served',
    },
    
    private: {
      type:      'Boolean',
      desc:      'Restrict pull access to explicitly authorized users. Defaults to unrestricted pull access.',
      default:   false,
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
    
    registry_path: {
      type:      'String',
      desc:      'The Registry hostame/name/ to use with docker pull command defined by this distribution.',
      behaviour: :read_only,
    },
    
    namespace: {
      type:      'String',
      desc:      'Namespace this distribution belongs to.',
      behaviour: :read_only,
    },
    
  },
)
