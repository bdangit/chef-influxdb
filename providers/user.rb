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
  @client      = InfluxDB::Helpers.client(new_resource.auth_username, new_resource.auth_password, run_context)
  @username    = new_resource.username
  @password    = new_resource.password
  @databases   = new_resource.databases
  @permissions = new_resource.permissions
end

action :create do
  unless @password
    fail('You must provide a password for the :create' \
         ' action on this resource')
  end
  @databases.each do |db|
    unless @client.list_users.map { |x| x['username'] || x['name'] }.member?(@username)
      @client.create_database_user(db, @username, @password)
    end
    @permissions.each do |permission|
      @client.grant_user_privileges(@username, db, permission)
    end
  end
end

action :update do
  @client.update_user_password(@username, @password) if @password
  @databases.each do |db|
    @permissions.each do |permission|
      @client.grant_user_privileges(@username, db, permission)
    end
  end
end

action :delete do
  if @client.list_users.map { |x| x['username'] || x['name'] }.member?(@username)
    @client.delete_user(@username)
  end
end
