# recipe: custom_data_path.rb
# NOTE: supposed that Influxdb was installed

# Mock mount disk0
directory '/mnt/disk0'

include_recipe 'influxdb::default'

# override default `lib_file_path`
node.default['influxdb']['lib_file_path'] = '/mnt/disk0/influxdb'
node.default['influxdb']['meta_file_path'] = "#{node['influxdb']['lib_file_path']}/meta"
node.default['influxdb']['data_file_path'] = "#{node['influxdb']['lib_file_path']}/data"
node.default['influxdb']['wal_file_path'] = "#{node['influxdb']['lib_file_path']}/wal"
node.default['influxdb']['hinted-handoff_file_path'] = "#{node['influxdb']['lib_file_path']}/hh"

directory node['influxdb']['lib_file_path'] do
  owner 'influxdb'
  group 'influxdb'
  mode 0755
end

# We need UDP for metrics database
# Making sure this override the attributes
node.default['influxdb']['config']['udp'] = [
  {
    'enabled' => true,
    'bind-address' => ":#{node['monitor']['influxdb']['udp_port']}",
    'database' => node['monitor']['influxdb']['database'],
    'batch-size' => 100,
    'batch-timeout' => '1s'
  }
]

node.default['influxdb']['config']['http']['auth-enabled'] = true

#  Rewrite influxdb.conf
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end

service 'influxdb' do
  action :nothing
end

# Because we enforce authentican, so admin must be created first,
# then create database
influxdb_admin node['influxdb']['admin_user'] do
  password node['influxdb']['admin_password']
  auth_username node['influxdb']['admin_user']
  auth_password node['influxdb']['admin_password']
  action :create
end

# Create  database for storing metrics
influxdb_database node['monitor']['influxdb']['database'] do
  action :create
  auth_username node['influxdb']['admin_user']
  auth_password node['influxdb']['admin_password']
end

influxdb_user node['monitor']['influxdb']['username'] do
  password node['monitor']['influxdb']['password']
  databases [node['monitor']['influxdb']['database']]
  permissions ['ALL']
  auth_username node['influxdb']['admin_user']
  auth_password node['influxdb']['admin_password']
end

# `policy_name` should be `name_attribute` but it is NOT
influxdb_retention_policy "#{node['monitor']['influxdb']['database']}_policy" do
  policy_name "#{node['monitor']['influxdb']['database']}_policy"
  database node['monitor']['influxdb']['database']
  duration node['monitor']['influxdb']['retention']['duration']
  replication node['monitor']['influxdb']['retention']['replication']
  auth_username node['influxdb']['admin_user']
  auth_password node['influxdb']['admin_password']
  action :create
end
