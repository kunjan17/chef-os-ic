# chef-os-ic

Install CentOS 6.4 minimal http://mirror.yandex.ru/centos/6.4/isos/x86_64/CentOS-6.4-x86_64-minimal.iso
Execute as root user

curl -s https://raw.github.com/laboshinl/openstack-havana-cookbook/master/bootstrap.sh | bash
Reboot
Change addreses in /root/floating-pool.sh and run it to create neutron external network
All done! Go to http://ipaddress/dashboard login: admin password: mySuperSecret
centos_cloud Cookbook

This cookbook installs openstack "havana".

####Neutron:

vlan
openvswitch
namespaces
####Compute:

kvm
####Glance:

swift backend
####Cinder:

lvm driver
####Includes:

heat
ceilometer
swift
Requirements

OS

CentOS 6.4 minimal x86_64
Interfaces

At least one network interface on controller and nodes
LVM

Volume group for cinder
cookbooks

simple_iptables - centos_cloud needs simple_iptables to manage iptables.
libcloud - centos_cloud needs libcloud to use scp, manage ssh-keys, etc.
selinux - centos_cloud needs selinux to disable selinux.
tar - centos_cloud needs tar to manage tar.gz
databags

openstack
$ knife data bag show ssh_keypairs openstack
id : openstack
private_key: -----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----
public_key: ssh-rsa ... user@host
Attributes

Key	Type	Description	Default
[:creds][:admin_password]	string	admin user password	mySuperSecret
[:creds][:mysql_password]	string	mysql root user password	r00tSqlPass
[:creds][:keystone_token]	string	keystone token	c6c5de883bfd0ef30a71
[:creds][:swift_hash]	string	swift hash	12c51e21fc2824fff5c5
[:creds][:quantum_secret]	string	quantum shared secret	c6c5de883bfd0ef30a71
[:creds][:ssh_keypair]	string	name of databag containing ssh-keypair	openstack
[:ip][:controller]	string	compute node ipaddress	node[:ipaddress]
[:ip][:qpid]	string	message broker ipaddress	[:ip][:controller]
[:ip][:keystone]	string	identity service ipaddress	[:ip][:controller]
[:ip][:swift]	string	objectstore service ipaddress	[:ip][:controller]
[:ip][:glance]	string	image service ipaddress	[:ip][:controller]
[:ip][:cinder]	string	block storage service ipaddress	[:ip][:controller]
[:ip][:quantum]	string	network service ipaddress	[:ip][:controller]
[:ip][:nova]	string	compute service ipaddress	[:ip][:controller]
[:ip][:heat]	string	cloudformation service ipaddress	[:ip][:controller]
[:ip][:ceilometer]	string	metric service ipaddress	[:ip][:controller]
Usage

Just include centos-cloud in your node's run_list:

{
  "run_list": [
    "recipe[centos-cloud]"
  ]
}
http://[IPADDRESS]/dashboard
login: admin password: mySuperSecret

Add compute node

{
  "ip" : { 
    "controller": "IPADDRESS"
  },
  "run_list": [
    "recipe[centos-cloud::node]"
  ]
}
Contributing

Fork the repository on Github
Create a named feature branch (like add_component_x)
Write you change
Write tests for your change (if applicable)
Run the tests, ensuring they all pass
Submit a Pull Request using Github
License and Authors
