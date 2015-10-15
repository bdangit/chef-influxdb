# Create a test database
influxdb_database 'test_database' do
  action :create
end

# Create a test user and give it access to the test database
influxdb_user 'test_user' do
  password 'test_password'
  databases ['test_database']
  action :create
end

# Create a test cluster admin
influxdb_admin 'test_admin' do
  password 'test_admin_password'
  action :create
end

# Create a test retention policy on the test database
influxdb_retention_policy 'test_policy' do
  policy_name 'default'
  database 'test_database'
  duration '1w'
  replication 1
  action :create
end
