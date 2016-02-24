node.default['influxdb']['config']['graphite'] = [
  {
    'enabled' => true
  }
]
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end

service 'influxdb' do
  action :nothing
end
