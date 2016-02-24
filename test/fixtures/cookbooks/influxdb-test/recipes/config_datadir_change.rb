#
# recipe: config_datadir_change.rb
# NOTE: also tested for InfluxDB UDP port
#

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
    'bind-address' => ':8089',
    'database' => 'test_database',
    'batch-size' => 100,
    'batch-timeout' => '1s'
  }
]

#  Rewrite influxdb.conf
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end

service 'influxdb' do
  action :nothing
end

# Create a test database
influxdb_database 'test_database' do
  action :create
end

# Create a test user and give it access to the test database
influxdb_user 'test_user' do
  password 'test_password'
  databases ['test_database']
  action :create
end

# Create a test cluster admin
influxdb_admin 'test_admin' do
  password 'test_admin_password'
  action :create
end

# Create a test retention policy on the test database
influxdb_retention_policy 'test_policy' do
  policy_name 'default'
  database 'test_database'
  duration '1w'
  replication 1
  action :create
end

# Finally, enable authorization
node.set['influxdb']['config']['http']['auth-enabled'] = true

influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end
