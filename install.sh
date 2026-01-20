#!/bin/bash


function install_tss2()
{
	apt-get -y install --no-install-recommends libtss2-dev libtss2-fapi1 libtss2-rc0 libtss2-tctildr0
}

function mkcrypttab()
{
    if [[ -f /etc/crypttab ]] ; then
        echo "WARNING:  using existing crypttab" 1>&2
    else
        echo "WARNING:  creating default crypttab" 1>&2
        ./mkcrypttab.sh >> /etc/crypttab
    fi
}

function prereqs_old()
{
	#sudo apt install libtss2-dev
	  #libtss2-dev libtss2-fapi1 libtss2-rc0 libtss2-tctildr0

	cat <<-EOF
	  1) You must have created /etc/crypttab
	    e.g.: luks /dev/sda2 none tpm2-device=auto
	    tip: can use blkid to get the UUID of the device too.

	  2) You must have installed necessary TSS2 libraries
	    e.g. sudo apt-get install libtss2-dev
	EOF

	read -p "Enter to continue"
}
function install_docker()
{
	apt-get install -y docker.io
}

function compile_systemd_with_tpm2()
{
	./build_systemd_with_tpm2_support.sh
}

function install_systemd_with_tpm2()
{
	dpkg -i systemd_249.11-0ubuntu*_amd64.deb libsystemd0_249.11-0ubuntu*_amd64.deb
}

function install_crypt_setup_mod_scripts()
{
	#apply patches:
	mkdir -p patched
	pushd patched >& /dev/null

	cp /usr/lib/cryptsetup/functions cryptsetup_functions
	cp /usr/share/initramfs-tools/scripts/local-top/cryptroot cryptroot

	patch cryptsetup_functions ../patches/cryptsetup_functions.patch
	patch cryptroot ../patches/cryptroot.patch

	cp cryptsetup_functions /usr/lib/cryptsetup/functions
	cp cryptroot /usr/share/initramfs-tools/scripts/local-top/cryptroot

	popd >& /dev/null

	#install the initramfs hook to include the required program and libtss2 in the initramfs
	cp scripts/systemd_cryptsetup_hook /etc/initramfs-tools/hooks
}

function update_initramfs()
{
	update-initramfs -u -k "$(uname -r)"
}

function tldr_just_work_old()
{
    #This compiles System D with TPM2 support.  Apparently not needed for a new install anymore, but left 'just in case'.
	prereqs_old && \
	install_docker && \
	compile_systemd_with_tpm2 && \
	install_systemd_with_tpm2 && \
	install_crypt_setup_mod_scripts && \
	update_initramfs && \
	echo SystemD with TPM2 installation complete.
}

function tldr_just_work()
{
	mkcrypttab && \
	install_tss2 && \
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
