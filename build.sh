#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"
### install flatpaks
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# flatpak -y install --system $(cat /tmp/packages/flatpaks)

### Install packages
rpm-ostree install \
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
