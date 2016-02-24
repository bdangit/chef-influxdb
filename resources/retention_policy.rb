# resources/database.rb

# Resource for InfluxDB database

property :name, String, name_property: true
property :policy_name, String
property :database, String
property :duration, String, default: 'INF'
property :replication, Fixnum, default: 1
property :default, [TrueClass, FalseClass], default: false
property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'

default_action :create

action :create do
  if current_policy
    if current_policy['duration'] != duration || current_policy['replicaN'] != replication || current_policy['default'] != default
      client.alter_retention_policy(policy_name, database, duration, replication, default)
      updated_by_last_action true
    end
  else
    client.create_retention_policy(policy_name, database, duration, replication, default)
    updated_by_last_action true
  end
end

action :delete do
  if current_policy
    client.delete_retention_policy(policy_name, database)
    updated_by_last_action true
  end
end

def current_policy
  @current_policy ||= (
    current_policy_arr = client.list_retention_policies(database).select do |p|
      p['name'] == policy_name
    end
    if current_policy_arr.length > 1
      Chef::Log.fatal("Unexpected number of matches for retention policy #{policy_name} on database #{database}: #{current_policy_arr}")
    end
    current_policy_arr[0] if current_policy_arr.length
  )
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
