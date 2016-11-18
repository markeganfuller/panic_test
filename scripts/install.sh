#!/bin/sh -eu

printf "# Setup vagrant's key\n"
date > /etc/vagrant_box_build_time
mkdir -pm 700 /home/vagrant/.ssh
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

yum update -y
yum groupinstall "Development Tools" -y
yum install strace nfs-utils git -y

# Setup nfs
sed -i 's/^.*RPCNFSDARGS.*$/RPCNFSDARGS="-V 4.2"/' /etc/sysconfig/nfs
mkdir -p /exports/bobby
mkdir /bobby_mount
echo "/exports/bobby 127.0.0.1/24(rw,no_root_squash)" >> /etc/exports
systemctl enable nfs-server nfs-mountd nfs-idmapd
systemctl restart nfs-server nfs-mountd nfs-idmapd

echo "127.0.0.1:/exports/bobby /bobby_mount nfs4 vers=4.2 0 0" >> /etc/fstab

# Setup serial boot - note requires reboot
sed -i 's/GRUB_CMDLINE_LINUX="\([^"]\+\)"/GRUB_CMDLINE_LINUX="\1 console=ttyS0"/' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# Setup Singularity
git clone https://github.com/singularityware/singularity.git
cd singularity
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc
make
make install
cd ..
rm -rf ./singularity
