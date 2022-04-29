
# Systemd-CryptSetup operation combined with initramfs-tools

## Installation:
### TLDR:
If you just 'want it to work'  then run `sudo ./install.sh`.  and everything *should* work.  It will install Docker on your host system and then do all the work inside docker, so there is minimal impact.  the CWD will get some extra packages added to it, plus some extra directories with source files inside, but you can ignore all of that - once the script has completed successfully this entire directory can be removed.

### I want to understand!
0. Read the scripts for full details of what's happening.  They've been documented by function names, and should be reasonably easy to understand both what's happening and why it is happening.
	start with install.sh 'tldr_just_Work' and read the rest of the functions from there.
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

Or, to build on this host directly:
./build_systemd_with_tpm2_support.sh on_this_host

