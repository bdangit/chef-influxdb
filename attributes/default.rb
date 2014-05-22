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
  x86_64: {
    '0.6.0' => 'b62b34b0e0163dd51108889bf16e0b7a3142b390d68fab50ce356fc40faf22fb',
    '0.6.5' => '8d04cc99d8f90d4a8743f526d9dd156ef4014866a9a3050e04605d1ffc32b2c9',
    :latest => '8d04cc99d8f90d4a8743f526d9dd156ef4014866a9a3050e04605d1ffc32b2c9'
  },
  i686: {
    '0.6.0' => '941727dfa39c216e1b9a04e520929e72919a5b57010e966150b9cbe215a514f4',
    '0.6.5' => '01a58f5b9042e4e021ab248838fa428277e0a9e0a1eaff8138a19d66d8433ce5',
    :latest => '01a58f5b9042e4e021ab248838fa428277e0a9e0a1eaff8138a19d66d8433ce5'
  },
  amd64: {
    '0.6.0' => '85a8f1f7a341999d8b21a14fcba05ea88b4e152c197213bbb3cfe6652f985dea',
    '0.6.5' => 'ea12d310ac951013ca4e959ee5b4cc961b7f5a2b80baebd89e98ad36c16cb29e',
    :latest => 'ea12d310ac951013ca4e959ee5b4cc961b7f5a2b80baebd89e98ad36c16cb29e'
  },
  i386: {
    '0.6.0' => '533044ae48ee6f2cc4eddbc212b530a0e807c8227bd0af9fa46c584d31a003dc',
    '0.6.5' => 'ef17098da3a0bf278bf5aa8664c4c328385711567fa9085fc7abd889d0219d0c',
    :latest => 'ef17098da3a0bf278bf5aa8664c4c328385711567fa9085fc7abd889d0219d0c'
  }
}

# Set the correct source url and checksum for used platform_family and configured version
if platform_family?('rhel', 'fedora')
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'x86_64' : 'i686'
  default[:influxdb][:source] = "http://s3.amazonaws.com/influxdb/influxdb-#{node[:influxdb][:version]}-1.#{arch}.rpm"
  default[:influxdb][:checksum] = node[:influxdb][:versions][arch][node[:influxdb][:version]]
elsif platform_family?('debian')
  arch = /x86_64/.match(node[:kernel][:machine]) ? 'amd64' : 'i386'
  default[:influxdb][:source] = "http://s3.amazonaws.com/influxdb/influxdb_#{node[:influxdb][:version]}_#{arch}.deb"
  default[:influxdb][:checksum] = node[:influxdb][:versions][arch][node[:influxdb][:version]]
end

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:ruby][:enable] = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version] = '0.1.4'

# Parameters to configure InfluxDB
default[:influxdb][:config] = {
  'bind-address' => '0.0.0.0',
  :logging => {
    :level => 'info',
    :file => 'influxdb.log'
  },
  :admin => {
    :port => 8083,
    :assets => '/opt/influxdb/current/admin'
  },
  :api => {
    'read-timeout' => '5s',
    :port => 8086
  },
  'input_plugins' => {
    :graphite => {
      :enabled => false
    }
  },
  raft: {
    :port => 8090,
    :dir => '/opt/influxdb/shared/data/raft'
  },
  storage: {
    'write-buffer-size' => 10_000,
    :dir => '/opt/influxdb/shared/data/db'
  },
  cluster: {
    'protobuf_port' => 8099,
    'protobuf_timeout' => '2s',
    'protobuf_heartbeat' => '200ms',
    'write-buffer-size' => 10_000,
    'max-response-buffer-size' => 100_000,
    'concurrent-shard-query-limit' => 10
  },
  leveldb: {
    'max-open-files' => 40,
    'lru-cache-size' => '200m',
    'max-open-shards' => 0,
    'point-batch-size' => 100
  },
  sharding: {
    'replication-factor' => 1,
    'short-term' => {
      :duration => '7d',
      :split => 1
    },
    'long-term' => {
      :duration => '30d',
      :split => 1
    }
  },
  wal: {
    :dir => '/opt/influxdb/shared/data/wal',
    'flush-after' => 1_000,
    'bookmark-after' => 1_000,
    'index-after' => 1_000,
    'requests-per-lifecycle' => 10_000
  }
}
