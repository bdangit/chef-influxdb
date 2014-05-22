# providers/default.rb
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
# LWRP for InfluxDB instance

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @root_pwd = new_resource.root_pwd
  @source = new_resource.source
  @version = new_resource.version
  @checksum = new_resource.checksum
  @config = new_resource.config
  @run_context = run_context
end

action :create do
  install_influxdb
  influxdb_service(:enable)
  create_config
end

action :start do
  influxdb_service(:start)
end

private

def install_influxdb
  path = ::File.join(Chef::Config[:file_cache_path], ::File.basename(@source))
  remote = Chef::Resource::RemoteFile.new(path, @run_context)
  remote.source(@source)
  remote.checksum(@checksum) if @checksum
  remote.run_action(:create)

  pkg = Chef::Resource::Package.new('influxdb', @run_context)
  pkg.source(path)
  pkg.version(@version)
  pkg.run_action(:install)

  if pkg.updated_by_last_action?
    action_start
    influxdb_admin = Chef::Resource::InfluxdbAdmin.new('root', @run_context)
    influxdb_admin.admin_pwd('root')
    influxdb_admin.password(@root_pwd)
    influxdb_admin.run_action(:update)
  end
end

def influxdb_service(action)
  s = Chef::Resource::Service.new('influxdb', @run_context)
  s.run_action(action)
end

def create_config
  InfluxDB::Helpers.render_config(@config, @run_context)
end

def set_root_password

end
