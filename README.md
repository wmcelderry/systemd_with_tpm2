
# Systemd-CryptSetup operation combined with initramfs-tools

## Installation:
1. cryptroot
	replaces /usr/share/initramfs/local-top/cryptroot
2. cryptsetup_functions
	replaces /usr/lib/cryptsetup/functions.sh
3. systemd_cryptsetup_hook
	adds to /etc/initramfs-tools/hooks

## Operation:
These files build on the 'cryptroot' module in initramfs-tools/cryptsetup to allow the ```bash /etc/crypttab``` file to support the 'tpm-device=xxx' option and pass it through to the systemd-crypsetup application to allow automatically decrypting a device using LUKS and a TPM.


## Compilation:

To compile Systemd with TPM2 support, the script ```build_systemd_with_tpm2_support.sh``` can be used to either build inside a fresh ubuntu:22.04 image, or on the host.

This will create the deb files for system in the current working directory.


To build inside a fresh docker image:
./build_systemd_with_tpm2_support.sh

OR
./build_systemd_with_tpm2_support.sh on_this_host

to build on this host directly.
