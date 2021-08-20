# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_file_repository',
  docs: <<-EOS,
@summary resource for creating pulpcore_file_repository
EOS
  features: [],
  attributes: {
    ensure: {
      type:    'Enum[present,absent]',
      desc:    'Adding docs for suppressing warnings',
      default: 'present',
    },
    name: {
      type:      'String',
      desc:      'Adding docs for suppressing warnings',
      behaviour: :namevar,
    },
    description: {
      type: 'Optional[String]',
      desc: 'Adding docs for suppressing warnings',
    },
    retained_versions: {
      type:    'Integer',
      desc:    'Adding docs for suppressing warnings',
      default: 1,
    },
    remote: {
      type: 'Optional[String]',
      desc: 'Adding docs for suppressing warnings',
    },
    autopublish: {
      type:    'Boolean',
      desc:    'Adding docs for suppressing warnings',
      default: false,
    },
    manifest: {
      type:    'String',
      desc:    'Adding docs for suppressing warnings',
      default: 'PULP_MANFEST',
    },
    pulp_href: {
      type:      'String',
      desc:      'Pulp href',
      behaviour: :read_only,
    },
    pulp_created: {
      type:      'String',
      desc:      'Timestamp of creation.',
      behaviour: :read_only,
    },
    versions_href: {
      type:      'String',
      desc:      'Timestamp of the most recent update of the remote.',
      behaviour: :read_only,
    },
  },
)
