#
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_container_container_remote',
  docs: <<-EOS,
@summary Resource for creating pulpcore_container_container_remote

This type provides Puppet with the capabilities to manage a pulp pulpcore_container_container_remote
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
      desc:      'A unique name for this remote.',
      behaviour: :namevar,
    },
    url: {
      type:      'String',
      desc:      'The URL of an external content source.',
    },
    ca_cert: {
      type:      'Optional[String]',
      desc:      'A PEM encoded CA certificate used to validate the server certificate presented by the remote server.',
    },
    client_cert: {
      type:      'Optional[String]',
      desc:      'A PEM encoded client certificate used for authentication.',
    },
    tls_validation: {
      type:      'Boolean',
      desc:      'If True, TLS peer validation must be performed.',
      default:   false,
    },
    proxy_url: {
      type:      'Optional[String]',
      desc:      'The proxy URL. Format: scheme://host:port',
    },
    pulp_labels: {
      type:      'Hash',
      desc:      'pulp_labels',
      default:   {},
    },
    download_concurrency: {
      type:      'Optional[Integer]',
      desc:      'Total number of simultaneous connections. If not set then the default value will be used.',
    },
    max_retries: {
      type:      'Optional[Integer]',
      desc:      'Maximum number of retry attempts after a download failure. If not set then the default value (3) will be used.',
    },
    policy: {
      type:      'Enum[immediate,on_demand,streamed]',
      # rubocop:disable Layout/LineLength
      desc:      ' immediate - All manifests and blobs are downloaded and saved during a sync. on_demand - Only tags and manifests are downloaded. Blobs are not downloaded until they are requested for the first time by a client. streamed - Blobs are streamed to the client with every request and never saved. * `immediate` - When syncing, download all metadata and content now. * `on_demand` - When syncing, download metadata, but do not download content now. Instead, download content as clients request it, and save it in Pulp to be served for future client requests. * `streamed` - When syncing, download metadata, but do not download content now. Instead,download content as clients request it, but never save it in Pulp. This causes future requests for that same content to have to be downloaded again.',
      # rubocop:enable Layout/LineLength
      default:   'immediate',
    },
    total_timeout: {
      type:      'Optional[Integer]',
      desc:      'aiohttp.ClientTimeout.total (q.v.) for download-connections. The default is null, which will cause the default from the aiohttp library to be used.',
    },
    connect_timeout: {
      type:      'Optional[Integer]',
      desc:      'aiohttp.ClientTimeout.connect (q.v.) for download-connections. The default is null, which will cause the default from the aiohttp library to be used.',
    },
    sock_connect_timeout: {
      type:      'Optional[Integer]',
      desc:      'aiohttp.ClientTimeout.sock_connect (q.v.) for download-connections. The default is null, which will cause the default from the aiohttp library to be used.',
    },
    sock_read_timeout: {
      type:      'Optional[Integer]',
      desc:      'aiohttp.ClientTimeout.sock_read (q.v.) for download-connections. The default is null, which will cause the default from the aiohttp library to be used.',
    },
    headers: {
      type:      'Array',
      desc:      'Headers for aiohttp.Clientsession',
      default:   [],
    },
    rate_limit: {
      type:      'Optional[Integer]',
      desc:      'Limits requests per second for each concurrent downloader',
    },
    upstream_name: {
      type:      'String',
      desc:      'Name of the upstream repository',
    },
    include_tags: {
      type:      'Optional[Array]',
      desc:      ' A list of tags to include during sync. Wildcards *, ? are recognized. `include_tags` is evaluated before `exclude_tags`. ',
      default:   [],
    },
    exclude_tags: {
      type:      'Optional[Array]',
      desc:      ' A list of tags to exclude during sync. Wildcards *, ? are recognized. `exclude_tags` is evaluated after `include_tags`. ',
      default:   [],
    },
    sigstore: {
      type:      'String',
      desc:      'A URL to a sigstore to download image signatures from',
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
      desc:      'Timestamp of the most recent update of the remote.',
      behaviour: :read_only,
    },
    hidden_fields: {
      type:      'Array',
      desc:      'List of hidden (write only) fields',
      default:   [],
      behaviour: :read_only,
    },
  },
)
