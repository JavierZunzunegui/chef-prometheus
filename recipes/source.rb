#
# Cookbook Name:: prometheus
# Recipe:: default
#
# Author: Ray Rodriguez <rayrod2030@gmail.com>
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

include_recipe 'build-essential::default'

user node['prometheus']['source']['user'] do
  system true
  shell '/bin/false'
  home node['prometheus']['dir']
  only_if { node['prometheus']['source']['use_existing_user'] == false }
end

directory node['prometheus']['dir'] do
  owner 'root'
  group node['root_group']
  mode '0755'
  recursive true
end

# These packages are needed go build
%w( curl git-core mercurial gzip sed ).each do |pkg|
  package pkg
end

git "#{Chef::Config[:file_cache_path]}/prometheus-#{node['prometheus']['source']['version']}" do
  repository node['prometheus']['source']['git_repository']
  revision node['prometheus']['source']['git_revision']
  action :checkout
end

bash 'compile_prometheus_source' do
  cwd "#{Chef::Config[:file_cache_path]}/prometheus-#{node['prometheus']['source']['version']}"
  code <<-EOH
    make build &&
    cp -R prometheus #{node['prometheus']['dir']} &&
    cp -R documentation/examples/prometheus.conf #{node['prometheus']['dir']} &&
    cp -R console_libraries #{node['prometheus']['dir']} &&
    cp -R consoles #{node['prometheus']['dir']}
  EOH

  not_if do
    File.exist?("#{node['prometheus']['dir']}/prometheus")
  end

  notifies :restart, 'service[prometheus]'
end

runit_service 'prometheus'

# rubocop:disable Style/HashSyntax
service 'prometheus' do
  supports :restart => true
end
# rubocop:enable Style/HashSyntax