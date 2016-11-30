node.default['influxdb']['config']['graphite'] = [
  {
    'enabled' => true
  }
]
influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end

influxdb_continuous_query 'test_cq' do
  database 'test_database'
  rewrite true
  query 'SELECT min(mouse) INTO min_mouse FROM zooo GROUP BY time(30m)'
  action :create
end

service 'influxdb' do
  action :nothing
end
