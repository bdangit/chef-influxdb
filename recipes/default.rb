# recipes/default.rb

# Installs InfluxDB

chef_gem 'toml-rb' do
  compile_time false if respond_to?(:compile_time)
end

chef_gem 'influxdb' do
  compile_time false if respond_to?(:compile_time)
end

influxdb_install 'influxdb' do
  action [:install]
end

influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
end

service 'influxdb' do
  action [:enable, :start]
end
