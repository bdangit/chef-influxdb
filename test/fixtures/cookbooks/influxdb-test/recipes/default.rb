include_recipe 'influxdb::default'

dbname = 'test_database'

# Create a test database
influxdb_database dbname do
  action :create
end

# Create a test user and give it access to the test database
influxdb_user 'test_user' do
  password 'test_password'
  databases [dbname]
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
  database dbname
  duration '1w'
  replication 1
  # by default in v1.0 there's a policy named autogen that is created for any
  # db, when `meta.retention-autocreate`=true. We will make this test_policy
  # the default policy.
  # ref1: https://docs.influxdata.com/influxdb/v1.0/query_language/database_management/#retention-policy-management
  # ref2: https://docs.influxdata.com/influxdb/v1.0/administration/config/#meta
  default true
  action :create
end

# Create a test continuous query on the test database
influxdb_continuous_query 'test_cq' do
  database dbname
  query 'SELECT min(mouse) INTO min_mouse FROM zoo GROUP BY time(30m)'
  action :create
end
