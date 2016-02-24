# recipe: custom_data_path.rb
# NOTE: supposed that Influxdb was installed

# Mock mount disk0
directory '/mnt/disk0'

# override default `lib_file_path`
node.override['influxdb']['lib_file_path'] = '/data/influxdb'
node.override['influxdb']['meta_file_path'] = "#{node['influxdb']['lib_file_path']}/meta"
node.override['influxdb']['data_file_path'] = "#{node['influxdb']['lib_file_path']}/data"
node.override['influxdb']['wal_file_path'] = "#{node['influxdb']['lib_file_path']}/wal"
node.override['influxdb']['hinted-handoff_file_path'] = "#{node['influxdb']['lib_file_path']}/hh"

directory node['influxdb']['lib_file_path'] do
  owner 'influxdb'
  group 'influxdb'
  mode 0755
end

# Restat to override node['influxdb']['config']
node.override['influxdb']['config']['meta']['dir'] = node['influxdb']['meta_file_path']
node.override['influxdb']['config']['data']['dir'] = node['influxdb']['data_file_path']
node.override['influxdb']['config']['data']['wal-dir'] = node['influxdb']['wal_file_path']
node.override['influxdb']['config']['hinted-handoff']['dir'] = node['influxdb']['hinted-handoff_file_path']
# We need UDP for metrics database
# Making sure this override the attributes
node.override['influxdb']['config']['udp'] = [
  {
      'enabled' => true,
      'bind-address' => ":#{node['monitor']['influxdb']['udp_port']}",
      'database' => node['monitor']['influxdb']['database'],
      'batch-size' => 100,
      'batch-timeout' => "1s"
  }
]

node.override['influxdb']['config']['http']['auth-enabled'] = true

#  Rewrite influxdb.conf
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
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
