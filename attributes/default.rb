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

# By default, always installs the latest by specifying nil
default[:influxdb][:version] = nil

# Grab clients -- right now only supports Ruby and CLI
default[:influxdb][:client][:cli][:enable] = false
default[:influxdb][:client][:ruby][:enable] = false
default[:influxdb][:client][:ruby][:version] = nil
default[:influxdb][:handler][:version] = '0.1.4'

# For influxdb versions >= 0.9.x
default[:influxdb][:install_root_dir] = '/opt/influxdb'
default[:influxdb][:log_dir] = '/var/log/influxdb'
default[:influxdb][:data_root_dir] = '/var/opt/influxdb'
default[:influxdb][:config_root_dir] = '/etc/opt/influxdb'
default[:influxdb][:config_file_path] = "#{node[:influxdb][:config_root_dir]}/influxdb.conf"

# For influxdb versions >= 0.9.x
default[:influxdb][:config] = {}

# Gem settings for the LWRPs
# Load a custom gem containing:
#  Fix show policies syntax: d929e386d4aa6203489eae47ad3e96b9b7c064cc - https://github.com/influxdb/influxdb-ruby/pull/109
#  Add alter_retention_policy(): 14595de93f1433f342ef4d03a09597df48f11feb - https://github.com/influxdb/influxdb-ruby/pull/114
# Built off https://github.com/CVTJNII/influxdb-ruby
default[:influxdb][:gem][:http_source] = 'https://github.com/CVTJNII/gemshare/raw/master/influxdb-0.2.3.gem'
