# resources/database.rb

# Resource for InfluxDB database

property :name, String, name_property: true
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

  next if client.list_databases.map { |x| x['name'] }.member?(new_resource.name)

  client.create_database(new_resource.name)
end

action :delete do
  client = client(new_resource)

  client.delete_database(new_resource.name)
end

