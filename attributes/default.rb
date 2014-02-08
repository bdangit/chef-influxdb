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
  'amd64' => {
    '0.3.0' => 'a6801a18a45793ad1afa121f023f21368b06216d433cfa2381f7288385f93af6',
    '0.4.3' => 'd2d1c69d8e888cbf0ec6f3a6a72a47dbc1d177c83151f95a7e51769616ec5431',
    'latest' => 'd2d1c69d8e888cbf0ec6f3a6a72a47dbc1d177c83151f95a7e51769616ec5431'
  },
  'i386' => {
    '0.3.0' => '1182b656a0c6e1ab8a28a2dcda0adab707df43258ba76e4ec5e05d61695b40ff',
    '0.4.3' => 'ae468726d096f7acf62fd96794356b1c2fa4d81789d67c48ed44f87add7bc0ea',
    'latest' => 'ae468726d096f7acf62fd96794356b1c2fa4d81789d67c48ed44f87add7bc0ea'
  }
}

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:ruby][:enable] = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version] = '0.1.4'

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

