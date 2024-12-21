#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Set hostname
echo L$(date +"%y%m") > /tmp/system_files/etc/hostname

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
sh /tmp/scripts/kvm.sh
sh /tmp/scripts/yubico.sh

### Enabling System Unit File(s)
systemctl enable rpm-ostreed-automatic.timer
systemctl enable tuned.service
systemctl enable docker.service
systemctl enable podman.socket
systemctl enable fstrim.timer

### Disabling System Unit File(s)
systemctl disable cosmic-greeter.service

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
