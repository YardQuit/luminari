# Universal Blue Custom Image
[universal-blue.org](https://universal-blue.org/)

## Purpose

This repository is meant to be a quick setup and restore for my personal use.

## Install

Rebase from an Fedora Atomic distribution:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/yardquit/luminari:latest
```

Rebase from an ublue distribution:
```bash
sudo bootc switch --enforce-container-sigpolicy ghcr.io/yardquit/luminari:latest
```

## Post Installs

### 1. YubiKey
To access the system using sudo, you will need to use your YubiKey as an additional factor of authentication. 
YubiKey Registration: 
Follow the below instructions to complete the registration process.
```bash
# Insert your YubiKey into a compatible USB port on your computer.
ykpamcfg -2
```
Ensure that YubiKey support is enabled and functional in your system settings.
```bash
sudo echo "Testing sudo with YubiKey"
```
Once your YubiKey is registered and supported by your system, you can use it to access the sudo command. 


### 2. fapolicyd
Enabling and Installing fapolicyd for Enhanced Security  

To secure your system, follow these steps to install, enable, and start fapolicyd.

Use the following command to install fapolicyd, its SELinux module, and a plugin for rpm-ostree.
```bash
rpm-ostree install fapolicyd fapolicyd-selinux rpm-plugin-fapolicyd
```
Restart your system for the changes take effect:
```bash
systemctl reboot
```
Configure the fapolicyd to allow repository packages, else fapolicyd will allow everything.
```bash
sudo sed -i 's/integrity = none/integrity = sha256/g' /etc/fapolicyd/fapolicyd.conf
```
Configure the fapolicyd service to start automatically on boot and enable it immediately.
```bash
sudo systemctl enable --now fapolicyd.service
``` 
