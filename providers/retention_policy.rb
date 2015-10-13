# providers/database.rb
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
# Creates or deletes an InfluxDB database

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @name    = new_resource.name
  @client  = InfluxDB::Helpers.client(new_resource.auth_username, new_resource.auth_password, run_context)

  @policy_name = new_resource.policy_name
  @database    = new_resource.database
  @duration    = new_resource.duration
  @replication = new_resource.replication
  @default     = new_resource.default
end

action :create do
  current_policy = _get_current_policy
  if current_policy
    if current_policy['duration'] != @duration || current_policy['replicaN'] != replication || current_policy['default'] != @default
      @client.alter_retention_policy(@policy_name, @database, @duration, @replication, @default)
    end
  else
      @client.create_retention_policy(@policy_name, @database, @duration, @replication, @default)
  end                                                   
end

action :delete do
  current_policy = _get_current_policy
  if current_policy
    @client.delete_retention_policy(@policy_name, @database)
  end
end

def _get_current_policy
  current_policy_arr = @client.list_retention_policies(@database).select { |p| p['name'] == @policy_name } 
  if current_policy_arr.length > 0
    fail("Unexpected number of matches for retention policy #{@policy_name} on database #{@database}: #{current_policy_arr}") if current_policy_arr.length > 1
    return current_policy_arr[0]
  else
    return nil
  end
end
