# libraries/matchers.rb

if defined?(ChefSpec)
  def create_influxdb_admin(admin_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_admin, :create, admin_user)
  end

  def update_influxdb_admin(admin_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_admin, :update, admin_user)
  end

  def delete_influxdb_admin(admin_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_admin, :delete, admin_user)
  end

  def create_influxdb_database(database_name)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_database, :create, database_name)
  end

  def delete_influxdb_database(database_name)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_database, :delete, database_name)
  end

  def create_influxdb_user(database_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_user, :create, database_user)
  end

  def update_influxdb_user(database_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_user, :update, database_user)
  end

  def delete_influxdb_user(database_user)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_user, :delete, database_user)
  end

  def create_influxdb_retention_policy(retention_policy)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_retention_policy, :create, retention_policy)
  end

  def delete_influxdb_retention_policy(retention_policy)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_retention_policy, :delete, retention_policy)
  end

  def create_influxdb_config(config)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_config, :create, config)
  end

  def delete_influxdb_config(config)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_config, :delete, config)
  end

  def install_influxdb_install(package)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_install, :install, package)
  end

  def remove_influxdb_install(package)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_install, :remove, package)
  end

  def create_influxdb_continuous_query(continuous_query)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_continuous_query, :create, continuous_query)
  end

  def delete_influxdb_continuous_query(continuous_query)
    ChefSpec::Matchers::ResourceMatcher.new(:influxdb_continuous_query, :delete, continuous_query)
  end
end
