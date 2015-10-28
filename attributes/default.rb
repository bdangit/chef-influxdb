# attributes/default.rb
#
# Author: Simple Finance <ops@simple.com>
# License: Apache License, Version 2.0
#
# Copyright 2013 Simple Finance Technology Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Attributes for InfluxDB

# Versions are mapped to checksums
# By default, always installs 'latest'
default[:influxdb][:version] = 'latest'

# Default influxdb recipe action. Consider [:create, :start]
default[:influxdb][:action] = [:create]

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:ruby][:enable] = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version] = '0.1.4'

# For influxdb versions >= 0.9.x
default[:influxdb][:install_root_dir] = "/opt/influxdb"
default[:influxdb][:log_dir] = "/var/log/influxdb"
default[:influxdb][:data_root_dir] = "/var/opt/influxdb"
default[:influxdb][:config_root_dir] = "/etc/opt/influxdb"
default[:influxdb][:config_file_path] = "#{node[:influxdb][:config_root_dir]}/influxdb.conf"

# Parameters to configure InfluxDB
if Gem::Version.new(node[:influxdb][:version]) < Gem::Version.new('0.9.0')
  # Based on https://github.com/influxdb/influxdb/blob/v0.8.5/config.sample.toml
  default[:influxdb][:config] = {
    'bind-address' => '0.0.0.0',
    'reporting-disabled' => false,
    logging: {
      level: 'info',
      file: '/opt/influxdb/shared/log.txt'
    },
    admin: {
      port: 8083,
    },
    api: {
      port: 8086,
      'read-timeout' => '5s'
    },
    input_plugins: {
      graphite: {
        enabled: false
      },
      udp: {
        enabled: false
      }
    },
    raft: {
      port: 8090,
      dir: '/opt/influxdb/shared/data/raft'
    },
    storage: {
      dir: '/opt/influxdb/shared/data/db',
      'write-buffer-size' => 10_000,
      'default-engine' => 'rocksdb',
      'max-open-shards' => 0,
      'point-batch-size' => 100,
      'write-batch-size' => 5_000_000,
      'retention-sweep-period' => '10m',
      engines: {
        leveldb: {
          'max-open-files' => 1000,
          'lru-cache-size' => '200m'
        },
        rocksdb: {
          'max-open-files' => 1000,
          'lru-cache-size' => '200m'
        },
        hyperleveldb: {
          'max-open-files' => 1000,
          'lru-cache-size' => '200m'
        },
        lmdb: {
          'map-size' => '100g'
        }
      }
    },
    cluster: {
      'protobuf_port' => 8099,
      'protobuf_timeout' => '2s',
      'protobuf_heartbeat' => '200ms',
      'protobuf_min_backoff' => '1s',
      'protobuf_max_backoff' => '10s',
      'write-buffer-size' => 1_000,
      'max-response-buffer-size' => 100,
      'concurrent-shard-query-limit' => 10
    },
    wal: {
      dir: '/opt/influxdb/shared/data/wal',
      'flush-after' => 1_000,
      'bookmark-after' => 1_000,
      'index-after' => 1_000,
      'requests-per-logfile' => 10_000
    }
  }
elsif Gem::Version.new(node[:influxdb][:version]) < Gem::Version.new('0.9.2')
  # For influxdb versions 0.9.0 and 0.9.1
  default[:influxdb][:config] = {
    hostname: "",
    'bind-address' => '0.0.0.0',
    port: 8086,
    'reporting-disabled' => false,
    initialization: {
      'join-urls' => "",
    },
    authentication: {
      enabled: false
    },
    admin: {
      enabled: true,
      port: 8083,
    },
    api: {
      'bind-address' => '0.0.0.0',
      'ssl-port' => nil,
      'ssl-cert' => nil,
      port: 8086,
      'read-timeout' => '5s'
    },
    graphite: [
      {
      enabled: false,
      protocol: "",
      'bind-address' => "0.0.0.0",
      port: 2003,
      'name-position' => "last",
      'name-separator' => "-",
      database: ""
      }
    ],
    collectd: {
      enabled: false,
      'bind-address' => "0.0.0.0",
      port: 25827,
      database: "collectd_database",
      typesdb: "types.db"
    },
    opentsdb: {
      enabled: false,
      'bind-address' => "0.0.0.0",
      port: 4242,
      database: "opentsdb_database"
    },
    udp: {
      enabled: false,
      'bind-address' => "0.0.0.0",
      port: 4444
    },
    broker: {
      enabled: true,
      dir:  "#{node[:influxdb][:data_root_dir]}/raft",
      'truncation-interval' => "10m",
      'max-topic-size' => 1073741824,
      'max-segment-size' => 10485760
    },
    raft: {
      'apply-interval' => "10ms",
      'election-timeout' => "1s",
      'heartbeat-interval' => "100ms",
      'reconnect-timeout' => "10ms"
    },
    data: {
      enabled: true,
      dir: "#{node[:influxdb][:data_root_dir]}/db",
      'retention-auto-create' => true,
      'retention-check-enabled' => true,
      'retention-check-period' => "10m"
    },
    snapshot: {
      enabled: true
    },
    logging: {
      'write-tracing' => false,
      'raft-tracing' => false,
      'http-access' => true,
      file: "#{node[:influxdb][:log_dir]}/influxd.log"
    },
    monitoring: {
      enabled: false,
      'write-interval' => "1m"
    }
  }
else
  # For influxdb versions >= 0.9.x
  # Based on https://github.com/influxdb/influxdb/blob/master/etc/config.sample.toml
  default[:influxdb][:config] = {

    'reporting-disabled' => false,
    meta: {
      'dir' => "#{node[:influxdb][:data_root_dir]}/meta",
      'hostname' => "",
      'bind-address' => ":8088",
      'retention-autocreate' => true,
      'election-timeout' => "1s",
      'heartbeat-timeout' => "1s",
      'leader-lease-timeout' => "500ms",
      'commit-timeout' => "50ms"
    },
    data: {
      'dir' => "#{node[:influxdb][:data_root_dir]}/data",
      'max-wal-size' => 104857600,
      'wal-dir' => "#{node[:influxdb][:data_root_dir]}/wal",
      'wal-enable-logging' => false,
      'wal-flush-interval' => "10m",
      'wal-partition-flush-delay' => "2s"
    },
    cluster: {
      'shard-writer-timeout' => "5s",
      'write-timeout' => "5s"
    },
    retention: {
      'enabled' => true,
      'check-interval' => "10m"
    },
    admin: {
      'enabled' => true,
      'bind-address' => ":8083",
      'https-enabled' => false,
      'https-certificate' => "/etc/ssl/influxdb.pem"
    },
    http: {
      'enabled' => true,
      'bind-address' => ":8086",
      'auth-enabled' => false,
      'log-enabled' => true,
      'write-tracing' => false,
      'pprof-enabled' => false,
      'https-enabled' => false,
      'https-certificate' => "/etc/ssl/influxdb.pem"
    },
    graphite: [
      {
        'enabled' => false,
        'bind-address' => ":2003",
        'protocol' => "tcp",
        'consistency-level' => "one",
        'name-separator' => ".",
        'batch-size' => 1000,
        'batch-timeout' => "1s",
        'name-schema' => "type.host.measurement.device",
        'ignore-unnamed' => true
      }
    ],
    collectd: {
      'enabled' => false,
      'bind-address' => ":25827",
      'database' => "collectd_database",
      'typesdb' => "types.db",
      'batch-size' => 1000,
      'batch-timeout' => "1s"
    },
    opentsdb: {
      'enabled' => false,
      'bind-address' => ":4242",
      'database' => "opentsdb_database",
      'retention-policy' => ""
    },
    udp: [
      {
        'enabled' => false,
      }
    ],
    monitoring: {
      'enabled' => true,
      'write-interval' => "1h"
    },
    continuous_queries: {
      'log-enabled' => true,
      'enabled' => true,
      'recompute-previous-n' => 2,
      'recompute-no-older-than' => "10m",
      'compute-runs-per-interval' => 10,
      'compute-no-more-than' => "2m"
    },
    :'hinted-handoff' => {
      'enabled' => true,
      'dir' => "/var/opt/influxdb/hh",
      'max-size' => 1073741824,
      'max-age' => "168h",
      'retry-rate-limit' => 0,
      'retry-interval' => "1s"
    }
  }
end
