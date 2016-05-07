module InfluxdbCookbook
  # helper functions to be used in resources
  module Helpers
    def determine_arch_type(new_resource, node)
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
  end
end
