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
default[:influxdb][:versions] = {
  amd64: {
    '0.3.0' => 'a6801a18a45793ad1afa121f023f21368b06216d433cfa2381f7288385f93af6',
    '0.4.3' => 'd2d1c69d8e888cbf0ec6f3a6a72a47dbc1d177c83151f95a7e51769616ec5431',
    '0.8.3' => 'c55b672cec4e745e8cbbd458dbac13824ca73ce42fac762ffe441809ebe9dab0',
    :latest => 'c55b672cec4e745e8cbbd458dbac13824ca73ce42fac762ffe441809ebe9dab0'
  },
  i386: {
    '0.3.0' => '1182b656a0c6e1ab8a28a2dcda0adab707df43258ba76e4ec5e05d61695b40ff',
    '0.4.3' => 'ae468726d096f7acf62fd96794356b1c2fa4d81789d67c48ed44f87add7bc0ea',
    '0.8.3' => '3110ba7e23e7660ca5dbfd133b492bf2aaad5a7743ffa4a22c44a115b37ef720',
    :latest => '3110ba7e23e7660ca5dbfd133b492bf2aaad5a7743ffa4a22c44a115b37ef720'
  }
}

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:ruby][:enable] = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version] = '0.1.4'

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
