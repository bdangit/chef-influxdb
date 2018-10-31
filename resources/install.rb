# resources/install.rb

# Resource for InfluxDB install

property :arch_type, String
property :include_repository, [TrueClass, FalseClass], default: true
property :influxdb_key, String, default: 'https://repos.influxdata.com/influxdb.key'
property :install_version, [String, nil], default: nil
property :install_type, String, default: 'package'
property :package_name, String, name_property: true
property :checksum, String, default: node['influxdb']['shasums'][node['platform_family']]
default_action :install

# rubocop:disable Style/MixinUsage
include InfluxdbCookbook::Helpers
# rubocop:enable Style/MixinUsage

# rubocop:disable Metrics/BlockLength
action :install do
  case new_resource.install_type
  when 'package'
    if platform_family? 'rhel'
      yum_repository 'influxdb' do
        description 'InfluxDB Repository - RHEL \$releasever'
        baseurl node['influxdb']['upstream_repository']
        gpgkey new_resource.influxdb_key
        only_if { new_resource.include_repository }
      end
    elsif platform_family? 'debian'
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
        arch new_resource.arch_type
        key new_resource.influxdb_key
        only_if { new_resource.include_repository }
      end
    else
      # NOTE: should raise to exit, instead of warn, since we failed to install InfluxDB
      raise "I do not support your platform: #{node['platform_family']}"
    end

    package 'influxdb' do
      version node['influxdb']['version'] if node['influxdb']['version']
      options '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"' if platform_family? 'debian'
    end
  when 'file'
    if platform_family? 'rhel'
      file_name = "#{new_resource.package_name}-#{new_resource.install_version}.x86_64.rpm"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['influxdb']['download_urls']['rhel']}/#{file_name}"
        checksum new_resource.checksum
        action :create
      end

      rpm_package new_resource.package_name do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        action :install
      end
    elsif platform_family? 'debian'
      # NOTE: file_name would be influxdb_<version> instead.
      file_name = "#{new_resource.package_name}_#{new_resource.install_version}_amd64.deb"
      remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
        source "#{node['influxdb']['download_urls']['debian']}/#{file_name}"
        checksum new_resource.checksum
        action :create
      end

      dpkg_package new_resource.package_name do
        source "#{Chef::Config[:file_cache_path]}/#{file_name}"
        options '--force-confdef --force-confold'
        action :install
      end
    else
      raise "I do not support your platform: #{platform_family?}"
    end
  else
    raise "#{new_resource.install_type} is not a valid install type."
  end
end
# rubocop:enable Metrics/BlockLength

action :remove do
  if platform_family? 'rhel'
    yum_repository 'influxdb' do
      action :delete
      only_if { new_resource.include_repository }
    end
  elsif platform_family? 'debian'
    apt_repository 'influxdb' do
      action :remove
      only_if { new_resource.include_repository }
    end
  else
    raise "I do not support your platform: #{platform_family?}"
  end

  package new_resource.package_name do
    action :remove
  end
end
