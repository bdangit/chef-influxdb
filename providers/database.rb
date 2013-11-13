# providers/database.rb
#
# Creates or deletes an InfluxDB database

include InfluxDB::Helpers

def initialize(new_resource, run_context)
  super
  @name = new_resource.name
  @cli  = InfluxDB::Helpers.client('root', 'root')
end

action :create do
  @cli.create_database(@name)
end

action :delete do
  @cli.delete_database(@name)
end

