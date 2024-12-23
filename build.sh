#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Copy pre-configured system files
rsync -rvK /tmp/system_files/ /

### Create system directory structues
mkdir -p /var/lib/alternatives

### Install packages
dnf install \
$(cat /tmp/packages/desktop) \
$(cat /tmp/packages/develop) \
$(cat /tmp/packages/fonts) \
$(cat /tmp/packages/multimedia) \
$(cat /tmp/packages/personal) \
$(cat /tmp/packages/security) \
$(cat /tmp/packages/temporary) \
$(cat /tmp/packages/virtual)

### Run configuration scripts
sh /tmp/scripts/script_template.sh

### Disabling System Unit File(s)
systemctl disable cosmic-greeter.service

### Enabling System Unit File(s)
systemctl enable rpm-ostreed-automatic.timer
systemctl enable tuned.service
systemctl enable docker.service
systemctl enable podman.socket
systemctl enable fstrim.timer

### Enable virtualization Unit File(s)
for drv in qemu interface network nodedev nwfilter secret storage; do
    systemctl enable virt${drv}d.service;
    systemctl enable virt${drv}d{,-ro,-admin}.socket;
done

### Enable nested virtualization
echo 'options kvm_intel nested=1' > /etc/modprobe.d/kvm_intel.conf

### Change default firewalld zone
cp /etc/firewalld/firewalld-workstation.conf /etc/firewalld/firewalld-workstation.conf.bak
sed -i 's/DefaultZone=FedoraWorkstation/DefaultZone=drop/g' /etc/firewalld/firewalld-workstation.conf

### Add yubico challange for sudo
cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
sed -i '/PAM-1.0/a\auth       required     pam_yubico.so mode=challenge-response' /etc/pam.d/sudo

### Clean Up
shopt -s extglob
rm -rf /tmp/* || true
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)
rm -rf /etc/yum.repos.d/1password.repo
rm -rf /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:gmaglione:podman-bootc.repo
rm -rf /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:pennbauman:ports.repo
rm -rf /etc/yum.repos.d/_copr_ryanabx-cosmic.repo
rm -rf /etc/yum.repos.d/atim-starship-fedora-41.repo
rm -rf /etc/yum.repos.d/fedorapeople.org.groups.virt.virtio-win.virtio-win.repo
