#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_deb_apt_repository',
  docs: <<-EOS,
@summary Resource for creating pulpcore_deb_apt_repository

This type provides Puppet with the capabilities to manage a pulp pulpcore_deb_apt_repository
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
    publish_upstream_release_fields: {
      type:      'Boolean',
      # rubocop:disable Layout/LineLength
      desc:      'Previously, pulp_deb only synced the Release file fields codename and suite, now version, origin, label, and description are also synced. Setting this setting to False will make Pulp revert to the old behaviour of using it`s own internal values for the new fields during publish. This is primarily intended to avoid a sudden change in behaviour for existing Pulp repositories, since many Release file field changes need to be accepted by hosts consuming the published repository. The default for new repositories is True.',
      # rubocop:enable Layout/LineLength
      default:   false,
    },
    signing_service: {
      type:      'Optional[String]',
      desc:      'A reference to an associated signing service. Used if AptPublication.signing_service is not set',
    },
    signing_service_release_overrides: {
      type:      'Hash',
      desc:      'A dictionary of Release distributions and the Signing Service URLs they should use.Example: {"bionic": "/pulp/api/v3/signing-services/433a1f70-c589-4413-a803-c50b842ea9b5/"}',
      default:   {},
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
