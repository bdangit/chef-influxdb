require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe 'influxdb' do
  describe user('influxdb') do
    it { is_expected.to exist }
  end

  describe service('influxdb') do
    it { is_expected.to be_running }
  end

  describe port(8083) do
    it { is_expected.to be_listening }
  end

  describe port(8086) do
    it { is_expected.to be_listening }
  end

  let(:influxdb_databases) do
    command('eval "$(which influx) -execute \"show databases\""').stdout
  end

  let(:influxdb_users) do
    command('eval "$(which influx) -execute \"show users\""').stdout
  end

  describe 'test_database' do
    let(:retention_policies) do
      command('eval "$(which influx) -execute \"show retention policies on test_database\""').stdout
    end

    it 'exists' do
      expect(influxdb_databases).to match(/test_database/)
    end

    describe 'default retention policy' do
      it 'exists' do
        expect(retention_policies).to match(/default/)
      end

      it 'is set for 1 week' do
        expect(retention_policies).to match(/default.*168h0m0s/)
      end

      it 'is set for 1 replica' do
        expect(retention_policies).to match(/default.*\s1\s/)
      end

      it 'is the default' do
        expect(retention_policies).to match(/default.*true/)
      end
    end

    let(:continuous_queries) do
      command('eval "$(which influx) -execute \"show continuous queries\""').stdout
    end

    describe 'test continuous queries' do
      it 'is exists' do
        expect(continuous_queries).to match(/test_cq/)
      end
    end
  end

  describe 'test_user' do
    it 'exists' do
      expect(influxdb_users).to match(/test_user/)
    end

    it 'is not an admin' do
      expect(influxdb_users).to match(/test_user.*false/)
    end
  end

  describe 'test_admin' do
    it 'exists' do
      expect(influxdb_users).to match(/test_admin/)
    end

    it 'is an admin' do
      expect(influxdb_users).to match(/test_admin.*true/)
    end
  end
end
# rubocop:enable Metrics/BlockLength
