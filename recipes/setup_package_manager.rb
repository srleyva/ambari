#
# Cookbook Name:: ambari
# Recipe:: setup_package_manager
#
# Copyright 2014, JULIEN PELLET
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

%w'wget'.each do | pack |
  package pack do
    action :install
  end
end

%w'openssl'.each do | pack |
  package pack do
    action :upgrade
  end
end


case node['platform']
when "redhat","centos","amazon","scientific"
  case node['platform_version'].to_i
  when 5
    yum_repo = node['ambari']['rhel_5_repo']
  when 6
    yum_repo = node['ambari']['rhel_6_repo']
  end
  remote_file "/etc/yum.repos.d/ambari.repo" do
    source yum_repo
  end
  not_if do
    ::File.exists?("/etc/yum.repos.d/ambari.repo")
  end
when "suse"
  remote_file "/etc/zypp/repos.d/ambari.repo" do
    source node['ambari']['suse_11_repo']
  end
  not_if do
    ::File.exists?("/etc/zypp/repos.d/ambari.repo")
  end
when "ubuntu"
  remote_file "/etc/apt/sources.list.d/HDP.list" do
    source node['ambari']['ubuntu_12_repo']
  end
  not_if do
    ::File.exists?("/etc/apt/sources.list.d/HDP.list")
  end
end
