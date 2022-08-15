#!/bin/bash

DEV="..."
echo "luks $(sudo blkid --output export "${DEV}"  | grep ^UUID) none tpm2-device=auto"
