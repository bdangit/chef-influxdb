# resources/database.rb

# Resource for InfluxDB database

property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'
property :api_hostname, String, default: 'localhost'
property :api_port, Integer, default: 8086
property :use_ssl, [TrueClass, FalseClass], default: false
property :retry_limit, Integer, default: 10
property :verify_ssl, [TrueClass, FalseClass], default: true

default_action :create

action :create do
  next if client.list_databases.map { |x| x['name'] }.member?(new_resource.name)

  client.create_database(new_resource.name)
end

action :delete do
  client.delete_database(new_resource.name)
end

# rubocop:disable Metrics/MethodLength
def client
  require 'influxdb'
  @client ||=
    InfluxDB::Client.new(
      username: auth_username,
      password: auth_password,
      retry: retry_limit,
      host: api_hostname,
      port: api_port,
      use_ssl: use_ssl,
      verify_ssl: verify_ssl
    )
end
# rubocop:enable Metrics/MethodLength
