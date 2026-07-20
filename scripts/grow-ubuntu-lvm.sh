#!/usr/bin/env bash

# Expands the Ubuntu root volume after the VM disk is increased in Proxmox.
# Defaults match my Ubuntu VM. Change them if the disk layout is different.

DISK="${DISK:-/dev/vda}"
PARTITION="${PARTITION:-3}"
PHYSICAL_VOLUME="${PV:-/dev/vda3}"
LOGICAL_VOLUME="${LV:-/dev/mapper/ubuntu--vg-ubuntu--lv}"

if [ "$EUID" -ne 0 ]; then
  echo "Run this script with sudo."
  exit 1
fi

if ! command -v growpart >/dev/null 2>&1; then
  echo "growpart is missing. Install it with:"
  echo "sudo apt install cloud-guest-utils"
  exit 1
fi

echo "Current disk layout:"
lsblk "$DISK"

echo
read -r -p "Continue expanding the root volume? Type yes: " ANSWER

if [ "$ANSWER" != "yes" ]; then
  echo "Cancelled."
  exit 0
fi

growpart "$DISK" "$PARTITION"
pvresize "$PHYSICAL_VOLUME"
lvextend -l +100%FREE "$LOGICAL_VOLUME"

FILESYSTEM=$(findmnt -n -o FSTYPE /)

if [ "$FILESYSTEM" = "ext4" ]; then
  resize2fs "$LOGICAL_VOLUME"
elif [ "$FILESYSTEM" = "xfs" ]; then
  xfs_growfs /
else
  echo "Unsupported filesystem: $FILESYSTEM"
  exit 1
fi

echo
echo "Updated root filesystem:"
df -h /
