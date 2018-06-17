# resources/continuous_query.rb

# Resource for InfluxDB database

property :database, String
property :query, String
property :rewrite, [TrueClass, FalseClass], default: false
property :resample_every, [String, NilClass], default: nil
property :resample_for, [String, NilClass], default: nil
property :auth_username, String, default: 'root'
property :auth_password, String, default: 'root'
property :api_hostname, String, default: 'localhost'
property :api_port, Integer, default: 8086
property :use_ssl, [TrueClass, FalseClass], default: false
property :retry_limit, Integer, default: 10
property :verify_ssl, [TrueClass, FalseClass], default: true

default_action :create

action :create do
  if current_cq
    if new_resource.rewrite
      client.delete_continuous_query(name, database)
      client.create_continuous_query(name, database, query, resample_every: resample_every, resample_for: resample_for)
      updated_by_last_action true
    else
      Chef::Log.info("The continuous query #{name} on #{database} already exists. Skip this step.")
    end
  else
    client.create_continuous_query(new_resource.name, new_resource.database, new_resource.query, resample_every: new_resource.resample_every, resample_for: new_resource.resample_for)
    new_resource.updated_by_last_action true
  end
end

action :delete do
  client.delete_continuous_query(new_resource.name, new_resource.database)
  new_resource.updated_by_last_action true
end

# rubocop:disable Metrics/AbcSize
def current_cq
  @current_cq ||= begin
    current_cq_arr = client.list_continuous_queries(database).select do |c|
      c['name'] == name
    end
    if current_cq_arr.length > 1
      Chef::Log.fatal("Unexpected number of matches for continuous query #{name} on database #{database}: #{current_policy_arr}")
    end
    current_cq_arr[0] if current_cq_arr.length
  end
end
# rubocop:enable Metrics/AbcSize

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
