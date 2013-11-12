# attributes/default.rb
#
# Attributes for InfluxDB

default[:influxdb][:source] = 'http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb'
default[:influxdb][:checksum] = 'a6801a18a45793ad1afa121f023f21368b06216d433cfa2381f7288385f93af6'

# Client sources -- activate others using one of : python, js, node, cli
default[:influxdb][:client][:enable] = ['ruby', 'cli']
default[:influxdb][:client][:python][:source] = 'https://github.com/influxdb/influxdb-python'
default[:influxdb][:client][:ruby][:source] = 'https://github.com/influxdb/influxdb-ruby'
default[:influxdb][:client][:js][:source] = 'https://github.com/influxdb/influxdb-js'
default[:influxdb][:client][:nodejs][:source] = 'https://github.com/bencevans/influxdb-nodejs'
default[:influxdb][:client][:cli][:source] = 'https://github.com/FGRibreau/influxdb-cli'

# Parameters to configure InfluxDB
# Set `node.default[:influxdb][:config][<PARAMETER>] = x` to override
default[:influxdb][:config] = {
  'AdminHttpPort'  => 8083,
  'AdminAssetsDir' => '/opt/influxdb/current/admin',
  'ApiHttpPort'    => 8086,
  'RaftServerPort' => 8090,
  'SeedServers'    => [],
  'DataDir'        => '/opt/influxdb/shared/data/db',
  'RaftDir'        => '/opt/influxdb/shared/data/raft'
}

