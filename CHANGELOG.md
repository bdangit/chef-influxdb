# Change Log

## [6.3.0](https://github.com/bdangit/chef-influxdb/tree/6.3.0) (2018-10-26)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.2.0...6.3.0)

**Merged pull requests:**

- add support to configure shard\_duration to retention\_policy resource [\#170](https://github.com/bdangit/chef-influxdb/pull/170) ([kjschnei001](https://github.com/kjschnei001))

## [6.2.0](https://github.com/bdangit/chef-influxdb/tree/6.2.0) (2018-06-17)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.1.3...6.2.0)

**Closed issues:**

- constant Custom resource influxdb\_admin from cookbook influxdb::InfluxDB [\#164](https://github.com/bdangit/chef-influxdb/issues/164)
- Activate http-auth security [\#163](https://github.com/bdangit/chef-influxdb/issues/163)

**Merged pull requests:**

- bump version [\#169](https://github.com/bdangit/chef-influxdb/pull/169) ([bdangit](https://github.com/bdangit))
- Fix foodcritic lints [\#168](https://github.com/bdangit/chef-influxdb/pull/168) ([bdangit](https://github.com/bdangit))
- update to latest chefdk and ubuntu 16.04 [\#166](https://github.com/bdangit/chef-influxdb/pull/166) ([bdangit](https://github.com/bdangit))
- fix cookbook for Chef 14 - prefix new\_resource [\#165](https://github.com/bdangit/chef-influxdb/pull/165) ([jtimberman](https://github.com/jtimberman))

## [6.1.3](https://github.com/bdangit/chef-influxdb/tree/6.1.3) (2017-10-10)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.1.2...6.1.3)

**Fixed bugs:**

- Make 'retry' argument of InfluxDB::Client configurable [\#150](https://github.com/bdangit/chef-influxdb/issues/150)

**Merged pull requests:**

- bump version [\#162](https://github.com/bdangit/chef-influxdb/pull/162) ([bdangit](https://github.com/bdangit))
- Make retry configurable [\#161](https://github.com/bdangit/chef-influxdb/pull/161) ([bdangit](https://github.com/bdangit))
- update release notes with publish step [\#160](https://github.com/bdangit/chef-influxdb/pull/160) ([bdangit](https://github.com/bdangit))

## [6.1.2](https://github.com/bdangit/chef-influxdb/tree/6.1.2) (2017-10-10)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.1.1...6.1.2)

**Merged pull requests:**

- bump version and update typos [\#159](https://github.com/bdangit/chef-influxdb/pull/159) ([bdangit](https://github.com/bdangit))
- update release notes [\#158](https://github.com/bdangit/chef-influxdb/pull/158) ([bdangit](https://github.com/bdangit))
- adding steps to release [\#157](https://github.com/bdangit/chef-influxdb/pull/157) ([bdangit](https://github.com/bdangit))

## [6.1.1](https://github.com/bdangit/chef-influxdb/tree/6.1.1) (2017-10-09)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.1.0...6.1.1)

**Merged pull requests:**

- make it easy to bump versions [\#156](https://github.com/bdangit/chef-influxdb/pull/156) ([bdangit](https://github.com/bdangit))
- update changelog [\#155](https://github.com/bdangit/chef-influxdb/pull/155) ([bdangit](https://github.com/bdangit))

## [6.1.0](https://github.com/bdangit/chef-influxdb/tree/6.1.0) (2017-10-06)
[Full Changelog](https://github.com/bdangit/chef-influxdb/compare/6.0.0...6.1.0)

**Closed issues:**

- No candidate version available for influxdb [\#144](https://github.com/bdangit/chef-influxdb/issues/144)

**Merged pull requests:**

- need to add this gem [\#154](https://github.com/bdangit/chef-influxdb/pull/154) ([bdangit](https://github.com/bdangit))
- Bump 6.1.0 [\#153](https://github.com/bdangit/chef-influxdb/pull/153) ([bdangit](https://github.com/bdangit))
- Use `github-changelog-generator` to help with this mundane task [\#152](https://github.com/bdangit/chef-influxdb/pull/152) ([bdangit](https://github.com/bdangit))
- ability to install InfluxDB Enterprise packages [\#151](https://github.com/bdangit/chef-influxdb/pull/151) ([anatolijd](https://github.com/anatolijd))
- Update to support latest toml-rb 1.0.0 gem [\#148](https://github.com/bdangit/chef-influxdb/pull/148) ([igorfraa](https://github.com/igorfraa))

# HISTORY

## 6.0.0
* [major] Removed support for 12.1 thru 12.4.
* [minor] Fix install of influxdb
    - `node['influxdb']['include_repository']` was getting set to `nil` even
    though custom resource `influxdb_install` set `include_repository`
    default to false.  To fix needed to set the node attribute to be set
    properly
    - fixed rubocop styling
    - fixed foodcritic lints
    - updated kitchen to test for Chef 13
    - updated wercker profile to use latest and greatest chefdk
* [patch] Use `Generator` class instead of `dump` method for config generation [#143](../../pull/143) (contributed by @ton31337)
    - *We are no longer using `toml-rb` and instead use `toml`*

## 5.2.2
* [patch] notifying influxes service after config change [#140](../../pull/140)
  (contributed by @nilroy)

## 5.2.1
* [patch] Add a `rake publish` target

## 5.2.0
* [minor] Add SSL support for API-based resources
  (contributed by @kjschnei001)

## 5.1.0
* [minor] add ability to renew continuous query record if it exist by option
  rewrite in lwrp (contributed by @cyberflow)
* [patch] fix #133 that prevented latest versions of influxdb to be installed
  installs of influxdb (contributed by @cyberflow)
* [patch] clean up rubocop #136

## 5.0.3
* [patch] Pass force options to package install to enable upgrades
  (contributed by @eheydrick)
* [patch] install InfluxDB 1.0.2 (contributed by @eheydrick)

## 5.0.2
* [patch] handle InfluxDB::Error when auth enabled without admin user
  (contributed by @jschnare)

## 5.0.1
* [patch] relax apt and yum dependencies (contributed by @dpattmann)

## 5.0.0
* [major] Support for 1.0.x which is **not backward compatible**
* [major] Updated apt cookbook pin to ~> 4.0
* [major] Updated yum cookbook pin to ~> 4.0
* [minor] Reduce number of TK Cases to 12.1, 12.7 and 12.14.
* [patch] removed specific branch used for `compat_resource`

## 4.4.1
* Add steps to cut release
* Fix invalid property type 'nil' in continuous query options (contributed by
  @kentarosasaki)

## 4.4.0
* Added support for file install type (contributed by @chrisduong)
* Added extra continuous query options (contributed by @cyberflow)
* Make docker default driver for Test Kitchen

## 4.3.0
* Added influxdb\_continuous\_query (contributed by @cyberflow)

## 4.2.0
* Added influxdb\_install resource (contributed by @majormoses)

## 4.1.0
* Updated attributes to support Influxdb 0.10.0
* Set default resource actions (:create is default)
* Fixed support for Chef-Client 12.6
* Fixed rubocop styling
* Added functional test to check restarts service restarts on config change

## 4.0.1
* License update from Apache 2.0 to MIT
  - transfer of ownership

## 4.0.0
* Support for RHEL
* Support for Chef-Client 12.1+
* Support 0.9.5+
* Added ChefSpec Matchers
* Use toml-rb instead of toml

## 3.0.0
* Update to influxdb gem 0.2.x, which is not backwards compatible (contributed
  by @cmjosh)

## 2.7.0
* Add :stop action, remove :delete action from influxdb resource (contributed
  by @alvaromorales)

## 2.6.2
* Allow configuration options for databases (contributed by @wosc)

## 2.6.1
* Enable custom version of influxdb gem (contributed by @kri5)

## 2.6.0
* Support for 0.9.x release of InfluxDB (contributed by @rberger)

## 2.5.0
* Move influxdb resource actions to an attribute (contributed by
  @directionless)

## 2.4.0
* Update default config for 0.8.5 and up (contributed by @tjwallace)

## 2.3.0
* Update checksums for 0.8.6 (contributed by @tjwallace)

## 2.2.2
* Touch logfile if it does not exist (contributed by @odolbeau)

## 2.2.1
* Updated `latest` checksum to be accurate (contributed by @nomadium)

## 2.2.0
* Added `dbadmin` parameter to `influxdb_user`, allowing granular control of
  which users are admins for which databases (contributed by @BarthV)

## 2.1.1
* User and admin deletion now idempotent (contributed by @flowboard)

## 2.1.0
* Multiple style and testing updates (contribued by @odolbeau)

## 2.0.4
* Default logfile path is now the Debian package default (contributed by
  @masarakki)

## 2.0.3
* Fixed typo in cluster admin check per InfluxDB 0.6.0 (contributed by @Chelo)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*