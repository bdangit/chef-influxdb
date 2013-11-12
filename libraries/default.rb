# libraries/influxdb.rb
#
# Helper methods for managing InfluxDB

require 'json'

class InfluxDB
  module Helpers

    def self.render_config(hash, run_context)
      f = Chef::Resource::File.new('/opt/influxdb/shared/config.json', run_context)
      f.owner('root')
      f.mode(00644)
      f.content(JSON.pretty_generate(hash) + "\n")
      f.run_action(:create)
      f.notifies(:restart, 'service[influxdb]', :delayed)

      return f
    end

  end
end

