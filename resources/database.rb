# resources/database.rb
#
# LWRP for InfluxDB database

actions(:create, :delete)
default_action(:create)

attribute(:name, :kind_of => String, :name_attribute => true)

