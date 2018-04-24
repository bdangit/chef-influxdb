# resources/admin.rb

# Resource for InfluxDB cluster admin

property :username, String, name_property: true
property :password, String
property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'
property :api_hostname, String, default: 'localhost'
property :api_port, Integer, default: 8086
property :use_ssl, [TrueClass, FalseClass], default: false
property :retry_limit, Integer, default: 10
property :verify_ssl, [TrueClass, FalseClass], default: true

default_action :create

include InfluxdbCookbook::Helpers

action :create do
  require 'influxdb'

  client = client(new_resource)

  unless new_resource.password
    Chef::Log.fatal('You must provide a password for the :create action on this resource!')
  end

  begin
    unless client.list_cluster_admins.member?(new_resource.username)
      client.create_cluster_admin(new_resource.username, new_resource.password)
    end
  rescue InfluxDB::Error => e
    # Exception due to missing admin user
    # https://influxdb.com/docs/v0.9/administration/authentication.html
    # https://github.com/chrisduong/chef-influxdb/commit/fe730374b4164e872cbf208c06d2462c8a056a6a
    raise e unless e.to_s.include? 'create admin user'

    client.create_cluster_admin(new_resource.username, new_resource.password)
  end
end

action :update do
  client = client(new_resource)

  unless new_resource.password
    Chef::Log.fatal('You must provide a password for the :update action on this resource!')
  end

  client.update_user_password(new_resource.username, new_resource.password)
end

action :delete do
  client = InfluxdbCookbook::Helpers.client(new_resource)

  if client.list_cluster_admins.member?(new_resource.username)
    client.delete_user(new_resource.username)
  end
end

