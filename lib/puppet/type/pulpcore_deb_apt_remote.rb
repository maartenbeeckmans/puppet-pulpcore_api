# 
# This type is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'pulpcore_deb_apt_remote',
  docs: <<-EOS,
@summary Resource for creating pulpcore_deb_apt_remote

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
      default: false,
    },
    
    proxy_url: {
      type:      'Optional[String]',
      desc:      'The proxy URL. Format: scheme://host:port',
    },
    
    pulp_labels: {
      type:      'Hash',
      desc:      'pulp_labels',
      default:   '{}',
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
      desc:      'The policy to use when downloading content. The possible values include: `immediate`, `on_demand`, and `streamed`. `immediate` is the default.',
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
    },
    
    rate_limit: {
      type:      'Optional[Integer]',
      desc:      'Limits total download rate in requests per second',
    },
    
    distributions: {
      type:      'String',
      desc:      'Whitespace separated list of distributions to sync. The distribution is the path from the repository root to the "Release" file you want to access. This is often, but not always, equal to either the codename or the suite of the release you want to sync. If the repository you are trying to sync uses "flat repository format", the distribution must end with a "/". Based on "/etc/apt/sources.list" syntax.',
    },
    
    components: {
      type:      'Optional[String]',
      desc:      'Whitespace separatet list of components to sync. If none are supplied, all that are available will be synchronized. Leave blank for repositores using "flat repository format".',
    },
    
    architectures: {
      type:      'Optional[String]',
      desc:      'Whitespace separated list of architectures to sync If none are supplied, all that are available will be synchronized. A list of valid architecture specification strings can be found by running "dpkg-architecture -L". A sync will download the intersection of the list of architectures provided via this field and those provided by the relevant "Release" file. Architecture="all" is always synchronized and does not need to be provided here.',
    },
    
    sync_sources: {
      type:      'Boolean',
      desc:      'Sync source packages',
      default: false,
    },
    
    sync_udebs: {
      type:      'Boolean',
      desc:      'Sync installer packages',
      default: false,
    },
    
    sync_installer: {
      type:      'Boolean',
      desc:      'Sync installer files',
      default: false,
    },
    
    gpgkey: {
      type:      'Optional[String]',
      desc:      'Gpg public key to verify origin releases against',
    },
    
    ignore_missing_package_indices: {
      type:      'Boolean',
      desc:      'By default, upstream repositories that declare architectures and corresponding package indices in their Release files without actually publishing them, will fail to synchronize. Set this flag to True to allow the synchronization of such "partial mirrors" instead. Alternatively, you could make your remote filter by architectures for which the upstream repository does have indices.',
      default: false,
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
    
  },
)
