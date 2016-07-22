# resources/install.rb

# Resource for InfluxDB install

property :arch_type, kind_of: String
property :include_repository, kind_of: [TrueClass, FalseClass], default: true
property :influxdb_key, kind_of: String, default: 'https://repos.influxdata.com/influxdb.key'
default_action :install

include InfluxdbCookbook::Helpers

action :install do
  if node.platform_family? 'rhel'
    yum_repository 'influxdb' do
      description 'InfluxDB Repository - RHEL \$releasever'
      baseurl node['influxdb']['upstream_repository']
      gpgkey influxdb_key
      only_if { include_repository }
    end
  elsif node.platform_family? 'debian'
    # see if we should auto detect
    unless new_resource.arch_type
      new_resource.arch_type determine_arch_type(new_resource, node)
    end

    package 'apt-transport-https' do
      action :install
    end

    apt_repository 'influxdb' do
      uri node['influxdb']['upstream_repository']
      distribution node['lsb']['codename']
      components ['stable']
      arch_type new_resource.arch_type
      key influxdb_key
      only_if { include_repository }
    end
  else
    Chef::Log.warn "I do not support your platform: #{node.platform_family}"
  end

  package 'influxdb' do
    version node['influxdb']['version']
  end
end

action :remove do
  if node.platform_family? 'rhel'
    yum_repository 'influxdb' do
      action :delete
      only_if { include_repository }
    end
  elsif node.platform_family? 'debian'
    apt_repository 'influxdb' do
      action :delete
      only_if { include_repository }
    end
  else
    Chef.Log.warn "I do not support your platform: #{node.platform_family}"
  end

  package 'influxdb' do
    action :remove
  end
end
