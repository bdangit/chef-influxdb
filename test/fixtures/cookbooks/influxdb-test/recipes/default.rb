include_recipe 'influxdb::default'

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

# Create a test continuous query on the test database
influxdb_continuous_query 'test_cq' do
  database 'test_database'
  query 'SELECT min(mouse) INTO min_mouse FROM zoo GROUP BY time(30m)'
  action :create
end
