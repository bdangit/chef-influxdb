# providers/user.rb
#
# Creates a InfluxDB user

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @cli       = InfluxDB::Helpers.client('root', 'root')
  @username  = new_resource.username
  @password  = new_resource.password
  @databases = new_resource.databases
end

action :create do
  @databases.each do |db|
    @cli.create_database_user(db, @username, @password)
  end
end

action :delete do
  Chef::Log.warning('Action delete unimplemented for resource influxdb_user')
  return
end

