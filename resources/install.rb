# resources/install.rb

# Resource for InfluxDB install

property :arch_type, kind_of: String
property :include_repository, kind_of: [TrueClass, FalseClass], default: true
property :influxdb_key, kind_of: String, default: 'https://repos.influxdata.com/influxdb.key'
property :install_version, [String, nil], default: nil
property :install_type, String, default: 'package'
default_action :install

include InfluxdbCookbook::Helpers

action :install do
  case install_type
  when 'package'
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
      # NOTE: should raise to exit, instead of warn, since we failed to install InfluxDB
      raise "I do not support your platform: #{node.platform_family}"
    end

    package 'influxdb' do
      version node['influxdb']['version']
    end
  when 'file'
    if node.platform_family? 'rhel'
      file_name = "influxdb-#{install_version}.x86_64.rpm"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['influxdb']['download_urls']['rhel']}/#{file_name}"
        checksum node['influxdb']['shasums']['rhel']
        action :create
      end

      rpm_package 'influxdb' do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        action :install
      end
    elsif node.platform_family? 'debian'
      # NOTE: file_name would be influxdb_<version> instead.
      file_name = "influxdb_#{install_version}_amd64.deb"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['influxdb']['download_urls']['debian']}/#{file_name}"
        checksum node['influxdb']['shasums']['debian']
        action :create
      end

      dpkg_package 'influxdb' do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        action :install
      end
    else
      raise "I do not support your platform: #{node.platform_family}"
    end
  else
    raise "#{install_type} is not a valid install type."
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
