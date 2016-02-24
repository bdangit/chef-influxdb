# resources/user.rb

# Resource for InfluxDB user

property :username, String, name_property: true
property :password, String
property :databases, Array, default: []
property :permissions, Array, default: []
property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'

default_action :create

action :create do
  unless password
    Chef::Log.fatal('You must provide a password for the :create action on this resource')
  end
  databases.each do |db|
    unless client.list_users.map { |x| x['username'] || x['name'] }.member?(username)
      client.create_database_user(db, username, password)
      updated_by_last_action true
    end
    permissions.each do |permission|
      client.grant_user_privileges(username, db, permission)
      updated_by_last_action true
    end
  end
end

action :update do
  client.update_user_password(username, password) if password
  databases.each do |db|
    permissions.each do |permission|
      client.grant_user_privileges(username, db, permission)
    end
  end
  updated_by_last_action true
end

action :delete do
  if client.list_users.map { |x| x['username'] || x['name'] }.member?(username)
    client.delete_user(username)
    updated_by_last_action true
  end
end

def client
  require 'influxdb'
  @client ||=
    InfluxDB::Client.new(
      username: auth_username,
      password: auth_password,
      retry: 10
    )
end
