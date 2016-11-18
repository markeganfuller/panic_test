#!/bin/sh -eu

printf "# Clean up\n"
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts gcc kernel-devel kernel-headers
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso
rm /etc/udev/rules.d/70-persistent-net.rules

printf "# Zero fill\n"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
