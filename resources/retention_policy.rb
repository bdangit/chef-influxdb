# resources/database.rb

# Resource for InfluxDB database

property :policy_name, String
property :database, String
property :duration, String, default: 'INF'
property :replication, Integer, default: 1
property :default, [TrueClass, FalseClass], default: false
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

  if current_policy(client)
    if @current_policy['duration'] != new_resource.duration || @current_policy['replicaN'] != new_resource.replication || @current_policy['default'] != new_resource.default
      client.alter_retention_policy(new_resource.policy_name, new_resource.database, new_resource.duration, new_resource.replication, new_resource.default)
    end
  else
    client.create_retention_policy(new_resource.policy_name, new_resource.database, new_resource.duration, new_resource.replication, new_resource.default)
  end
end

action :delete do
  client = client(new_resource)

  if current_policy(client)
    client.delete_retention_policy(new_resource.policy_name, new_resource.database)
  end
end

action_class.class_eval do
  def current_policy(client)
    @current_policy ||= begin
      current_policy_arr = client.list_retention_policies(new_resource.database).select do |p|
        p['name'] == new_resource.policy_name
      end
      if current_policy_arr.length > 1
        Chef::Log.fatal("Unexpected number of matches for retention policy #{new_resource.policy_name} on database #{new_resource.database}: #{current_policy_arr}")
      end
      current_policy_arr[0] if current_policy_arr.length
    end
  end
end

