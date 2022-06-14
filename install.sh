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
	#apply patches:
	mkdir -p patched
	pushd patched >& /dev/null

	cp /usr/lib/cryptsetup/functions cryptsetup_functions
	cp /usr/share/initramfs_tools/scripts/local-top/cryptroot cryptroot

	patch cryptsetup_functions ../patches/cryptsetup_functions.patch
	patch cryptroot ../patches/cryptroot.patch

	cp cryptsetup_functions /usr/lib/cryptsetup/functions
	cp cryptroot /usr/share/initramfs_tools/scripts/local-top/cryptroot

	popd >& /dev/null

	#install the initramfs hook to include the required program and libtss2 in the initramfs
	cp scripts/systemd_cryptsetup_hook /etc/initramfs-tools/hooks
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
