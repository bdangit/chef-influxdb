#
# recipe: config_datadir_change.rb
# NOTE: also tested for InfluxDB UDP port
#

# Mock mount disk0
directory '/mnt/disk0'

# New lib_file_path
node.default['influxdb']['lib_file_path'] = '/mnt/disk0/influxdb'

# Restate these for consistent way with upstream cookbook
node.default['influxdb']['meta_file_path'] = "#{node['influxdb']['lib_file_path']}/meta"
node.default['influxdb']['data_file_path'] = "#{node['influxdb']['lib_file_path']}/data"
node.default['influxdb']['wal_file_path'] = "#{node['influxdb']['lib_file_path']}/wal"
node.default['influxdb']['hinted-handoff_file_path'] = "#{node['influxdb']['lib_file_path']}/hh"

# override by restating nested attributes
node.default['influxdb']['config']['meta']['dir'] = "#{node['influxdb']['lib_file_path']}/meta"
node.default['influxdb']['config']['data']['dir'] = "#{node['influxdb']['lib_file_path']}/data"
node.default['influxdb']['config']['data']['wal-dir'] = "#{node['influxdb']['lib_file_path']}/wal"
node.default['influxdb']['config']['hinted-handoff']['dir'] = "#{node['influxdb']['lib_file_path']}/hh"

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

include_recipe 'influxdb::default'

# Create custom datadir, after influxdb user created
directory node['influxdb']['lib_file_path'] do
  owner 'influxdb'
  group 'influxdb'
  mode 0755
end

#  Rewrite influxdb.conf
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end

include_recipe 'influxdb-test::_config_datadir_change_auth'
