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
case node.platform_family
when 'rhel'
  default[:influxdb][:version] = 'latest-1'
else  
  default[:influxdb][:version] = 'latest'
end

case node.platform_family
when 'rhel'
  default[:influxdb][:versions] = {
    x86_64: {
      'latest-1' => '321b14c3cf7c94f56506f432847c85c2f6080cb5f25b35c83fb2aa14cb843007'
    },
    i686: {
      'latest-1' => 'a0ff244d18418b2fee3294905096d34e981f2af147cd533c300a27153a94dd68'
    }
  }
else
  default[:influxdb][:versions] = {
    amd64: {
      '0.8.5' => '58ae034557e6a2886530577ab368ed2153b4e0a41bcfa57d8b15a9d5006f14d0',
      :latest => '58ae034557e6a2886530577ab368ed2153b4e0a41bcfa57d8b15a9d5006f14d0'
    },
    i686: {
      '0.8.5' => 'b551d6d152c9af6e66a1eba3c07578a20678d0d3f3efa8852f19e2befd96a7fd',
      :latest => 'b551d6d152c9af6e66a1eba3c07578a20678d0d3f3efa8852f19e2befd96a7fd'
    }
  }
end

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable]   = false
default[:influxdb][:client][:ruby][:enable]  = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version]       = '0.1.4'

# Parameters to configure InfluxDB
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
