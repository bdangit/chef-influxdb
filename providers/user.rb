# providers/user.rb
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
# Creates a InfluxDB user

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @client    = InfluxDB::Helpers.client('root', 'root')
  @username  = new_resource.username
  @password  = new_resource.password
  @databases = new_resource.databases
end

action :create do
  @databases.each do |db|
    @client.create_database_user(db, @username, @password)
  end
end

action :delete do
  Chef::Log.warning('Action delete unimplemented for resource influxdb_user')
  return
end

