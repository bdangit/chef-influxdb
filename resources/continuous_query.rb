# resources/continuous_query.rb

# Resource for InfluxDB database

property :name, String, name_property: true
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

include InfluxdbCookbook::Helpers

action :create do
  client = client(new_resource)

  if current_cq
    if rewrite
      client.delete_continuous_query(new_resource.name, new_resource.database)
      client.create_continuous_query(new_resource.name, new_resource.database, new_resource.query, resample_every: new_resource.resample_every, resample_for: new_resource.resample_for)
    else
      Chef::Log.info("The continuous query #{new_resource.name} on #{new_resource.database} already exists. Skip this step.")
    end
  else
    client.create_continuous_query(new_resource.name, new_resource.database, new_resource.query, resample_every: new_resource.resample_every, resample_for: new_resource.resample_for)
  end
end

action :delete do
  client = client(new_resource)

  client.delete_continuous_query(new_resource.name, new_resource.database)
end

action_class.class_eval do
  # rubocop:disable Metrics/AbcSize
  def current_cq
    @current_cq ||= begin
      current_cq_arr = client.list_continuous_queries(new_resource.database).select do |c|
        c['name'] == new_resource.name
      end
      if current_cq_arr.length > 1
        Chef::Log.fatal("Unexpected number of matches for continuous query #{new_resource.name} on database #{new_resource.database}: #{current_policy_arr}")
      end
      current_cq_arr[0] if current_cq_arr.length
    end
  end
  # rubocop:enable Metrics/AbcSize
end

