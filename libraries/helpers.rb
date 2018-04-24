
module InfluxdbCookbook
  # helper functions to be used in resources
  module Helpers
    def determine_arch_type(new_resource, node)
      require 'influxdb'

      if new_resource.arch_type
        new_resource.arch_type.to_s
      else
        case node['kernel']['machine']
        when /64/
          'amd64'
        when /386/
          'i386'
        end
      end
    end

    # rubocop:disable Metrics/MethodLength
    def client(new_resource)
      InfluxDB::Client.new(
        username: new_resource.auth_username,
        password: new_resource.auth_password,
        retry: new_resource.retry_limit,
        host: new_resource.api_hostname,
        port: new_resource.api_port,
        use_ssl: new_resource.use_ssl,
        verify_ssl: new_resource.verify_ssl
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end

