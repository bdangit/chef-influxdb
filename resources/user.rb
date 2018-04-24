# resources/user.rb

# Resource for InfluxDB user

property :username, String, name_property: true
property :password, String
property :databases, Array, default: []
property :permissions, Array, default: []
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
  client = client(new_resource)

  unless new_resource.password
    Chef::Log.fatal('You must provide a password for the :create action on this resource')
  end
  new_resource.databases.each do |db|
    unless client.list_users.map { |x| x['username'] || x['name'] }.member?(new_resource.username)
      client.create_database_user(db, new_resource.username, new_resource.password)
    end
    new_resource.permissions.each do |permission|
      client.grant_user_privileges(new_resource.username, db, permission)
    end
  end
end

action :update do
  client = client(new_resource)

  client.update_user_password(new_resource.username, new_resource.password) if new_resource.password
  new_resource.databases.each do |db|
    new_resource.permissions.each do |permission|
      client.grant_user_privileges(new_resource.username, db, permission)
    end
  end
end

action :delete do
  client = client(new_resource)

  if client.list_users.map { |x| x['username'] || x['name'] }.member?(new_resource.username)
    client.delete_user(new_resource.username)
  end
end

