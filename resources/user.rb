# resources/user.rb
#
# LWRP for InfluxDB user

actions(:create, :delete)
default_action(:create)

attribute(:username, :kind_of => String, :name_attribute => true)
attribute(:password, :kind_of => String, :required => true)
attribute(:databases, :kind_of => Array, :required => true)

