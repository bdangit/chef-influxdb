# recipes/ruby_client.rb

# Installs the InfluxDB Ruby client

gem_package 'influxdb' do
  version node['influxdb']['client']['ruby']['version']
  action :install
end
