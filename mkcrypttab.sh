#!/bin/bash

dev="${1}"
volname="${2:-luks}"

if [[ -z "${dev}" ]]; then
    #default to use current root.
    dev="$(mount  | grep 'on / ' | awk '{print $1;}')"
    echo "Cryptab: Defaulting to current root device: ${dev}" 1>&2
fi

echo "${volname} $(sudo blkid --output export "${dev}"  | grep ^UUID) none tpm2-device=auto"
