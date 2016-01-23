# recipes/default.rb

# Installs InfluxDB

chef_gem 'toml-rb' do
  compile_time false if respond_to?(:compile_time)
end

chef_gem 'influxdb' do
  compile_time false if respond_to?(:compile_time)
end

if platform_family? 'rhel'
  yum_repository 'influxdb' do
    description 'InfluxDB Repository - RHEL \$releasever'
    baseurl node['influxdb']['upstream_repository']
    gpgkey 'https://repos.influxdata.com/influxdb.key'
  end
else
  package 'apt-transport-https'

  apt_repository 'influxdb' do
    uri node['influxdb']['upstream_repository']
    distribution node['lsb']['codename']
    components ['stable']
    arch 'amd64'
    key 'https://repos.influxdata.com/influxdb.key'
  end
end

package 'influxdb' do
  version node['influxdb']['version']
end

influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
end

service 'influxdb' do
  action [:enable, :start]
end
