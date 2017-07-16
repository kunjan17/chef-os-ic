
# Recipe:: neutron

include_recipe "::opendaylight"
include_recipe "::openvswitch"

  database "neutron" do
  password node[:creds][:mysql_password]
end

%w[
neutron-dhcp-agent 
neutron-l3-agent
neutron-metadata-agent
neutron-lbaas-agent
neutron-server
].each do |srv|
  service srv do
    action [:enable,:start]
  end
end

execute "ovs-vsctl add-br br-ex" do
  not_if("ovs-vsctl list-br | grep br-ex")
  action :run
end

=begin
template "/etc/sysconfig/network-scripts/ifcfg-" + node[:auto][:external_nic]  do
  not_if do
    File.exists?("/etc/sysconfig/network-scripts/ifcfg-br-ex")
  end
  owner "root"
  group "root"
  mode  "0644"
  source "neutron/ifcfg-ethX.erb"
end
=end
template "/etc/sysconfig/network-scripts/ifcfg-br-ex" do
  not_if do
    File.exists?("/etc/sysconfig/network-scripts/ifcfg-br-ex")
  end
  owner "root"
  group "root"
  mode  "0644"
  source "neutron/ifcfg-br-ex-2.erb"
end
=begin
service "network" do
  action :restart
end
=end

template "/etc/neutron/metadata_agent.ini" do
  source "neutron/metadata_agent.ini.erb"
  notifies :restart, "service[neutron-metadata-agent]"
end

template "/etc/neutron/dhcp_agent.ini" do
  source "neutron/dhcp_agent.ini.erb"
  notifies :restart, "service[neutron-dhcp-agent]"
end

template "/etc/neutron/lbaas_agent.ini" do
  source "neutron/lbaas_agent.ini.erb"
  notifies :restart, "service[neutron-lbaas-agent]"
end

libcloud_file_append "/etc/neutron/dnsmasq-neutron.conf" do
  line ["dhcp-option-force=26,1454"]
end

template "/etc/neutron/l3_agent.ini" do
  source "neutron/l3_agent.ini.erb"
  notifies :restart, "service[neutron-l3-agent]"
end

#Help with configuting public network
template "/root/floating-pool.sh" do
  source "neutron/floating-pool.erb"
  owner "root"
  group "root"
  mode "0744"
end
