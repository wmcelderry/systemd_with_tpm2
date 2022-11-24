#!/bin/bash

DEV="${1}"

if [[ -z "${DEV}" ]]; then
    #default to use current root.
    DEV="$(mount  | grep 'on / ' | awk '{print $1;}')"
    echo "Defaulting to current root device: ${DEV}" 1>&2
fi

echo "luks $(sudo blkid --output export "${DEV}"  | grep ^UUID) none tpm2-device=auto"
