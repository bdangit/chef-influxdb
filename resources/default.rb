# resources/default.rb
#
# LWRP for InfluxDB user

actions(:create, :start, :delete)
default_action(:create)

attribute(:name, :kind_of => String, :name_attribute => true)
attribute(:source, :kind_of => String, :required => true)
attribute(:checksum, :kind_of => String, :required => false)
attribute(:config, :kind_of => Hash, :required => false)

