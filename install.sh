#!/bin/bash

function install_docker()
{
	apt install -y docker.io
}

function compile_systemd_with_tpm2()
{
	./build_systemd_with_tpm2_support.sh
}

function install_systemd_with_tpm2()
{
	dpkg -i systemd_249.11-0ubuntu3_amd64.deb
}

function install_crypt_setup_mod_scripts()
{
	cp cryptsetup_functions.sh /usr/lib/cryptsetup/functions.sh
	cp cryptroot /usr/share/initramfs_tools/scripts/local-top/cryptroot
	cp systemd_cryptsetup_hook /etc/initramfs-tools/hooks
}

function update_initramfs()
{
	update-initramfs -u -k "$(uname -r)"
}

function tldr_just_work()
{
	install_docker && \
	compile_systemd_with_tpm2 && \
	install_systemd_with_tpm2 && \
	install_crypt_setup_mod_scripts && \
	update_initramfs && \
	echo SystemD with TPM2 installation complete.
}


if [[ "${EUID}" -ne 0 ]] ; then
	echo "This script must be run as root.  Try:
		sudo $0
		"
	exit 1
fi

tldr_just_work
