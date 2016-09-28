# attributes/default.rb

# Attributes for InfluxDB

default['influxdb']['version'] = '1.0.0-1'
default['influxdb']['install_type'] = 'package'

default['influxdb']['download_urls'] = {
  'debian' => 'https://dl.influxdata.com/influxdb/releases',
  'rhel' => 'https://dl.influxdata.com/influxdb/releases'
}

# platform_family keyed download sha256 checksums
default['influxdb']['shasums'] = {
  'debian' => '567005b50ab71ff7445f220093f008c9f42b9bce52a5e5568734e5fb5765b515',
  'rhel' => '5cb2b3699ef28cdb1ff7888aafcb1012d5c51b212ab216eea7a2436de658f8c7'
}

# Grab clients -- right now only supports Ruby and CLI
default['influxdb']['client']['cli']['enable'] = false
default['influxdb']['client']['ruby']['enable'] = false
default['influxdb']['client']['ruby']['version'] = nil
default['influxdb']['handler']['version'] = '0.1.4'

# For influxdb versions >= 1.0.x
default['influxdb']['lib_file_path'] = '/var/lib/influxdb'
default['influxdb']['meta_file_path'] = "#{node['influxdb']['lib_file_path']}/meta"
default['influxdb']['data_file_path'] = "#{node['influxdb']['lib_file_path']}/data"
default['influxdb']['wal_file_path'] = "#{node['influxdb']['lib_file_path']}/wal"
# default['influxdb']['hinted-handoff_file_path'] = "#{node['influxdb']['lib_file_path']}/hh"
default['influxdb']['ssl_cert_file_path'] = '/etc/ssl/influxdb.pem'
default['influxdb']['config_file_path'] = '/etc/influxdb/influxdb.conf'

# For influxdb versions >= 1.0.x
# ref: https://docs.influxdata.com/influxdb/v1.0/administration/config/
default['influxdb']['config'] = {
  'reporting-disabled' => false,
  'bind-address' => ':8088',
  'meta' => {
    'dir' => node['influxdb']['meta_file_path'],
    'retention-autocreate' => true,
    'logging-enabled' => true
  },
  'data' => {
    'dir' => node['influxdb']['data_file_path'],
    'engine' => 'tsm1',
    'wal-dir' => node['influxdb']['wal_file_path'],
    'wal-logging-enabled' => true,
    'query-log-enabled' => true,
    'cache-max-memory-size' => 524_288_000,
    'cache-snapshot-memory-size' => 26_214_400,
    'cache-snapshot-write-cold-duration' => '1h0m0s',
    'compact-full-write-cold-duration' => '24h0m0s',
    'max-points-per-block' => 0,
    'trace-logging-enabled' => false
  },
  'coordinator' => {
    'write-timeout' => '10s',
    'max-concurrent-queries' => 0,
    'query-timeout' => '0',
    'log-queries-after' => '0',
    'max-select-point' => 0,
    'max-select-series' => 0,
    'max-select-buckets' => 0
  },
  'retention' => {
    'enabled' => true,
    'check-interval' => '30m0s'
  },
  'shard-precreation' => {
    'enabled' => true,
    'check-interval' => '10m0s',
    'advance-period' => '30m0s'
  },
  'admin' => {
    'enabled' => true,
    'bind-address' => ':8083',
    'https-enabled' => false,
    'https-certificate' => node['influxdb']['ssl_cert_file_path']
  },
  'monitor' => {
    'store-enabled' => true,
    'store-database' => '_internal',
    'store-interval' => '10s'
  },
  'subscriber' => {
    'enabled' => true,
    'http-timeout' => '30s'
  },
  'http' => {
    'enabled' => true,
    'bind-address' => ':8086',
    'auth-enabled' => false,
    'log-enabled' => true,
    'write-tracing' => false,
    'pprof-enabled' => false,
    'https-enabled' => false,
    'https-certificate' => node['influxdb']['ssl_cert_file_path'],
    'https-private-key' => '',
    'max-row-limt' => 10_000,
    'max-connection-limit' => 0,
    'shared-secret' => '',
    'realm' => 'InfluDB'
  },
  'graphite' => [
    {
      'enabled' => false
    }
  ],
  'collectd' => [
    {
      'enabled' => false
    }
  ],
  'opentsdb' => [
    {
      'enabled' => false
    }
  ],
  'udp' => [
    {
      'enabled' => false
    }
  ],
  'continuous_queries' => {
    'log-enabled' => true,
    'enabled' => true,
    'run-interval' => '1s'
  }
}

case node['platform_family']
when 'rhel', 'fedora'
  default['influxdb']['upstream_repository'] = case node['platform']
                                               when 'centos'
                                                 "https://repos.influxdata.com/centos/#{node['platform_version'].to_i}/$basearch/stable"
                                               when 'amazon'
                                                 # ref: https://aws.amazon.com/amazon-linux-ami/faqs/
                                                 'https://repos.influxdata.com/centos/6/$basearch/stable'
                                               else
                                                 "https://repos.influxdata.com/rhel/#{node['platform_version'].to_i}/$basearch/stable"
                                               end
else
  default['influxdb']['upstream_repository'] = "https://repos.influxdata.com/#{node['platform']}"
end
