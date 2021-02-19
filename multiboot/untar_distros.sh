#!/bin/bash

# Read partition UUIDs from the new disk and update /etc/fstab for
# every distro. Also update cumulatative grub.cfg for REDOS.

help()
{
	echo "Usage: $0 <dev>"
	exit 1
}

if [ $# -ne 1 ]; then
  help
fi
# Choose which newly partitioned disk to work on
TARGET_DEV="$1"

# End of configurable parameters

echo "Untar EFI ..."
tar cf - -C ./d_1 . | tar xpf - -C /tmp/efi
sync
echo "Untar REDOS ..."
tar cf - --exclude='./tmp' -C ./d_2 . | tar xpf - -C /tmp/redos
sync
echo "Untar EDELW ..."
tar cf - --exclude='./tmp' -C ./d_3 . | tar xpf - -C /tmp/edelw
sync
echo "Untar ALT ..."
tar cf - --exclude='./tmp' -C ./d_5 . | tar xpf - -C /tmp/alt
sync
echo "Untar ASTRA ..."
tar cf - --exclude='./tmp' -C ./d_6 . | tar xpf - -C /tmp/astra
sync
echo "Untar WAYLAND ..."
tar cf - --exclude='./tmp' -C ./d_7 . | tar xpf - -C /tmp/wayland
sync
echo "Untar Ubuntu ..."
tar cf - --exclude='./tmp' -C ./d_8 . | tar xpf - -C /tmp/ubuntu
sync

efi_uuid=$(/usr/sbin/blkid ${TARGET_DEV}1 | sed 's/.* UUID="\([^"]*\).*$/\1/')
redos_uuid=$(/usr/sbin/blkid ${TARGET_DEV}2 | sed 's/.* UUID="\([^"]*\).*$/\1/')
edelw_uuid=$(/usr/sbin/blkid ${TARGET_DEV}3 | sed 's/.* UUID="\([^"]*\).*$/\1/')
swap_uuid=$(/usr/sbin/blkid ${TARGET_DEV}4 | sed 's/.* UUID="\([^"]*\).*$/\1/')
alt_uuid=$(/usr/sbin/blkid ${TARGET_DEV}5 | sed 's/.* UUID="\([^"]*\).*$/\1/')
astra_uuid=$(/usr/sbin/blkid ${TARGET_DEV}6 | sed 's/.* UUID="\([^"]*\).*$/\1/')
wayland_uuid=$(/usr/sbin/blkid ${TARGET_DEV}7 | sed 's/.* UUID="\([^"]*\).*$/\1/')
ubuntu_uuid=$(/usr/sbin/blkid ${TARGET_DEV}8 | sed 's/.* UUID="\([^"]*\).*$/\1/')

# Edit /etc/fstab files
sed -e 's/EFI_STUB/'${efi_uuid}'/; s/SWAP_STUB/'${swap_uuid}'/;
s/REDOS_STUB/'${redos_uuid}'/;' fstab.redos.template > /tmp/redos/etc/fstab

sed -e 's/EFI_STUB/'${efi_uuid}'/; s/SWAP_STUB/'${swap_uuid}'/; 
s/EDELW_STUB/'${edelw_uuid}'/;' fstab.edelw.template >  /tmp/edelw/etc/fstab

sed -e 's/EFI_STUB/'${efi_uuid}'/; s/SWAP_STUB/'${swap_uuid}'/;
s/ALT_STUB/'${alt_uuid}'/;' fstab.alt.template >  /tmp/alt/etc/fstab

sed -e 's/EFI_STUB/'${efi_uuid}'/; s/SWAP_STUB/'${swap_uuid}'/;
s/ASTRA_STUB/'${astra_uuid}'/;' fstab.astra.template >  /tmp/astra/etc/fstab

sed -e 's/EFI_STUB/'${efi_uuid}'/; s/SWAP_STUB/'${swap_uuid}'/;
s/WAYLAND_STUB/'${wayland_uuid}'/;' fstab.wayland.template >  /tmp/wayland/etc/fstab

sed -e 's/EFI_STUB/'${efi_uuid}'/;
s/UBUNTU_STUB/'${ubuntu_uuid}'/;' fstab.ubuntu.template >  /tmp/ubuntu/etc/fstab


sed -e 's/REDOS_STUB/'${redos_uuid}'/; s/EDELW_STUB/'${edelw_uuid}'/;
s/ALT_STUB/'${alt_uuid}'/; s/ASTRA_STUB/'${astra_uuid}'/;
s/WAYLAND_STUB/'${wayland_uuid}'/; 
s/UBUNTU_STUB/'${ubuntu_uuid}'/;' grub.template > /tmp/redos/boot/grub2/grub.cfg

sed -e 's/EDELW_STUB/'${edelw_uuid}'/;' efi_grub.template > /tmp/efi/EFI/debian/grub.cfg
sed -e 's/EDELW_STUB/'${edelw_uuid}'/;' startup.nsh.template > /tmp/efi/startup.nsh

