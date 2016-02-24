# resources/database.rb

# Resource for InfluxDB database

property :name, String, name_property: true
property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'

default_action :create

action :create do
  next if client.list_databases.map { |x| x['name'] }.member?(name)

  client.create_database(name)
  updated_by_last_action true
end

action :delete do
  client.delete_database(name)
  updated_by_last_action true
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
