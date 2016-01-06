# recipes/default.rb
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
# Installs InfluxDB

chef_gem 'toml' do
  compile_time false if respond_to?(:compile_time)
end

chef_gem 'influxdb' do
  compile_time false if respond_to?(:compile_time)
end

if platform_family? 'rhel'
  yum_repository 'influxdb' do
    description 'InfluxDB Repository - RHEL \$releasever'
    baseurl node['influxdb']['upstream_repository']
    gpgkey 'https://repos.influxdata.com/influxdb.key'
  end
else
  package 'apt-transport-https'

  apt_repository 'influxdb' do
    uri node['influxdb']['upstream_repository']
    distribution node['lsb']['codename']
    components ['stable']
    arch 'amd64'
    key 'https://repos.influxdata.com/influxdb.key'
  end
end

package 'influxdb' do
  version node['influxdb']['version']
end

influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
end

service 'influxdb' do
  action [:enable, :start]
end
