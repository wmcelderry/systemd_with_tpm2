#!/bin/bash


function enable_source_packages()
{
	sed -i 's/# deb-src/deb-src/g' /etc/apt/sources.list
}

function update_apt()
{
	apt-get update
}


function install_dependencies()
{
	apt-get install -y build-essential fakeroot dpkg-dev libtss2-dev
}

function get_systemd_build_dependencies()
{
	apt-get build-dep -y systemd
}
function get_systemd_src()
{
	apt-get source systemd
}

function build_systemd_with_tpm2_support()
{
		cd systemd-249.11
		sed -i 's/tpm2=false/tpm2=true/g' debian/rules
		dpkg-buildpackage -rfakeroot -uc -b 
}


case $1 in
	"in_docker")
		enable_source_packages
		update_apt
		install_dependencies
		get_systemd_build_dependencies
		get_systemd_src
		build_systemd_with_tpm2_support
		;;
	*)
		docker run --rm -it -v $(pwd):/build -w /build ubuntu:22.04 ./build_systemd_with_tpm2_support.sh "in_docker"
		;;
esac


