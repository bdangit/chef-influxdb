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

default[:influxdb][:source] = 'http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb'
default[:influxdb][:checksum] = 'a6801a18a45793ad1afa121f023f21368b06216d433cfa2381f7288385f93af6'

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:cli][:source] = 'https://github.com/FGRibreau/influxdb-cli'
default[:influxdb][:client][:ruby][:enable] = false

# Parameters to configure InfluxDB
# Set `node.default[:influxdb][:config][<PARAMETER>] = x` to override
default[:influxdb][:config] = {
  'AdminHttpPort'  => 8083,
  'AdminAssetsDir' => '/opt/influxdb/current/admin',
  'ApiHttpPort'    => 8086,
  'RaftServerPort' => 8090,
  'SeedServers'    => [],
  'DataDir'        => '/opt/influxdb/shared/data/db',
  'RaftDir'        => '/opt/influxdb/shared/data/raft'
}

