#!/bin/bash

dev="${1}"
volname="${2:-luks}"

if [[ -z "${dev}" ]]; then
    #default to use current root.
    dev=$(awk '{if ( $2 == "/") { print $1}}' /proc/mounts)
    echo "Cryptab: Defaulting to current root device: ${dev}" 1>&2
fi

echo "${volname} $(lsblk -n -o uuid "${dev}") none tpm2-device=auto"
