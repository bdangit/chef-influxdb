# providers/admin.rb
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
# Manages InfluxDB cluster administrator

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @client    = InfluxDB::Helpers.client(new_resource.auth_username, new_resource.auth_password, run_context)
  @username  = new_resource.username
  @password  = new_resource.password
end

action :create do
  unless @password
    Chef::Log.fatal!('You must provide a password for the :create' \
                     ' action on this resource!')
  end

  begin
    unless @client.list_cluster_admins.member?(@username)
      @client.create_cluster_admin(@username, @password)
    end
  rescue InfluxDB::AuthenticationError => e
    # Exception due to missing admin user
    # https://influxdb.com/docs/v0.9/administration/authentication.html
    # https://github.com/chrisduong/chef-influxdb/commit/fe730374b4164e872cbf208c06d2462c8a056a6a
    if e.to_s.include? 'create admin user'
      @client.create_cluster_admin(@username, @password)
    end
  end
end

action :update do
  unless @password
    Chef::Log.fatal!('You must provide a password for the :update' \
                     ' action on this resource!')
  end
  @client.update_user_password(@username, @password)
end

action :delete do
  if @client.list_cluster_admins.member?(@username)
    @client.delete_user(@username)
  end
end
