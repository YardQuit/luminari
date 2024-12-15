#!/usr/bin/env bash
set -oue pipefail

# enable virtualization services
for drv in qemu interface network nodedev nwfilter secret storage; do
    systemctl enable virt${drv}d.service;
    systemctl enable virt${drv}d{,-ro,-admin}.socket;
done

# enable nested virtualization
echo 'options kvm_intel nested=1' > /etc/modprobe.d/kvm_intel.conf

