# resources/database.rb
#
# License: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# LWRP for InfluxDB database

actions(:create, :delete)
default_action(:create)

attribute(:name, kind_of: String, name_attribute: true)

attribute(:policy_name, kind_of: String)
attribute(:database,    kind_of: String)
attribute(:duration,    kind_of: String, default: 'INF')
attribute(:replication, kind_of: Fixnum, default: 1)
attribute(:default,     kind_of: [TrueClass, FalseClass], default: false)

attribute(:auth_username, kind_of: String, default: 'root')
attribute(:auth_password, kind_of: String, default: 'root')

