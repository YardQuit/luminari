#!/usr/bin/env bash
set -oue pipefail

# add yubico challange for sudo
sed -i '/PAM-1.0/a\auth       required     pam_yubico.so mode=challenge-response' /etc/pam.d/sudo
