# recipes/default.rb
#
# Installs InfluxDB

class Chef::Recipe
  include InfluxDB::Helpers
end

path = ::File.join(Chef::Config[:file_cache_path], 'influxdb.deb')
remote_file path do
  source node[:influxdb][:source]
  checksum node[:influxdb][:checksum]
  action :create
end

package path do
  provider Chef::Provider::Package::Dpkg
  action :install
end

service 'influxdb' do
  action :enable
end

InfluxDB::Helpers.render_config(node[:influxdb][:config], run_context)

