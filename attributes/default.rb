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

# https://github.com/influxdb/influxdb/blob/v0.9.3/etc/config.sample.toml
# Versions are mapped to checksums
# By default, always installs 'latest'
default[:influxdb][:version] = 'latest'

# Default influxdb recipe action. Consider [:create, :start]
default[:influxdb][:action] = [:create, :start]

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
default[:influxdb][:auth_enabled] =  false

# For influxdb versions >= 0.9.x
default[:influxdb][:config] = {
  'reporting-disabled' => true,
  # Meta node configuration
  # Controls the parameters for the Raft consensus group that stores metadata
  # about the InfluxDB cluster.
  meta: {
    dir: "#{node[:influxdb][:data_root_dir]}/meta",
    hostname: "localhost",
    'bind-address' => ":8088",
    'retention-autocreate' => true,
    'election-timeout' => "1s",
    'heartbeat-timeout' => "1s",
    'leader-lease-timeout' => "500ms",
    'commit-timeout' => "50ms"
  },

  data: {
    dir: "#{node[:influxdb][:data_root_dir]}/data",
    'max-wal-size' => 104857600,
    'wal-flush-interval' => "10m",
    'wal-partition-flush-delay' => "2s",
    'wal-dir' => "#{node[:influxdb][:data_root_dir]}/wal",
    'wal-enable-logging' => true
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
    'auth-enabled' => node[:influxdb][:auth_enabled],
    'log-enabled' => true,
    'write-tracing' => false,
    'pprof-enabled' => false,
    'https-enabled' => false,
    'https-certificate' => "/etc/ssl/influxdb.pem"
  },

  graphite: [
    {
    enabled: false,
    protocol: "", # Set to "tcp" or "udp"
    'bind-address' => "0.0.0.0", # If not set, is actually set to bind-address.
    port: 2003,
    'name-position' => "last",
    'name-separator' => "-",
    database: ""  # store graphite data in this database
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

  udp: [{
    enabled: false,
    'bind-address' => "0.0.0.0",
    port: 4444
  }],

  monitoring: {
    enabled: false,
    'write-interval' => "1m"          # Period between writing the data.
  },

  continuous_queries: {
    'log-enabled' => true,
    'enabled' => true,
    'recompute-previous-n' => 2,
    'recompute-no-older-than' => "10m",
    'compute-runs-per-interval' => 10,
    'compute-no-more-than' => "2m"
  },

  'hinted-handoff' => {
    'enabled' => true,
    'dir' => "#{node[:influxdb][:data_root_dir]}/hh",
    'max-size' => 1073741824,
    'max-age' => "168h",
    'retry-rate-limit' => 0,
    'retry-interval' => "1s"
  }
}
