# Recipe: _config_datadir_change_auth

# Create a test database
influxdb_database 'test_database' do
  auth_username 'test_admin'
  auth_password 'test_admin_password'
  action :create
end

# Create a test user and give it access to the test database
influxdb_user 'test_user' do
  auth_username 'test_admin'
  auth_password 'test_admin_password'
  password 'test_password'
  databases ['test_database']
  action :create
end

# Create a test cluster admin
influxdb_admin 'test_admin' do
  auth_username 'test_admin'
  auth_password 'test_admin_password'
  password 'test_admin_password'
  action :create
end

# Create a test retention policy on the test database
influxdb_retention_policy 'test_policy' do
  auth_username 'test_admin'
  auth_password 'test_admin_password'
  policy_name 'default'
  database 'test_database'
  duration '1w'
  replication 1
  action :create
end

# Finally, enable authorization
node.set['influxdb']['config']['http']['auth-enabled'] = true

influxdb_config node['influxdb']['config_file_path'] do
  config node['influxdb']['config']
  notifies :restart, 'service[influxdb]'
end
