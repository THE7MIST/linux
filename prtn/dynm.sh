#!/bin/bash

echo "======================================"
echo " Dynamic Partitioning Learning Tool"
echo "======================================"

echo ""
echo "[STEP 1] View available disks"
echo "Command: lsblk"
echo "This shows all disks and partitions."
lsblk

read -p "  Enter disk (e.g. /dev/sdb): " DISK

echo ""
echo "[STEP 2] Select partition type"
echo "1. Primary (standard partition)"
echo "2. Extended (container for logical)"
echo "3. Logical (inside extended)"
read -p "  Choice: " TYPE

case $TYPE in
  1) PTYPE="primary"; FDISK_TYPE="p";;
  2) PTYPE="extended"; FDISK_TYPE="e";;
  3) PTYPE="logical"; FDISK_TYPE="";;
  *) echo "Invalid choice"; exit;;
esac

read -p "  Enter size (e.g. +2G): " SIZE

echo ""
echo "[STEP 3] Creating partition using fdisk"
echo "Command: fdisk $DISK"
echo "We will create a $PTYPE partition of size $SIZE"

fdisk $DISK <<EOF
n
$FDISK_TYPE

$SIZE
w
EOF

echo ""
echo "[STEP 4] Reload partition table"
echo "Command: partprobe"
partprobe

echo ""
echo "[VERIFY] Check partition creation"
echo "Command: lsblk"
lsblk

read -p "  Enter created partition (e.g. /dev/sdb1): " PART

echo ""
echo "[STEP 5] Choose filesystem"
echo "1. xfs (default in CentOS)"
echo "2. ext4"
echo "3. ext3"
echo "4. swap"
read -p "  Choice: " FSTYPE

case $FSTYPE in
  1) FS="xfs";;
  2) FS="ext4";;
  3) FS="ext3";;
  4) FS="swap";;
  *) echo "Invalid"; exit;;
esac

echo ""
echo "[STEP 6] Formatting partition"

if [ "$PTYPE" != "extended" ]; then
  if [ "$FS" == "swap" ]; then
    echo "Command: mkswap $PART"
    mkswap $PART

    echo "Command: swapon $PART"
    swapon $PART

    echo "[VERIFY] Swap status"
    swapon --show
    free -h
  else
    echo "Command: mkfs.$FS $PART"
    mkfs.$FS $PART

    echo "[VERIFY] Filesystem"
    lsblk -f
  fi
else
  echo "⚠ Extended partition cannot be formatted"
fi

# Mounting
if [ "$FS" != "swap" ] && [ "$PTYPE" != "extended" ]; then

  echo ""
  echo "[STEP 7] Mounting"

  read -p "  Do you want to mount? (y/n): " MNT

  if [ "$MNT" == "y" ]; then
    read -p "  Enter mount point (e.g. /data1): " MP

    echo "Command: mkdir -p $MP"
    mkdir -p $MP

    echo "Command: mount $PART $MP"
    mount $PART $MP

    echo "[VERIFY] Mounted partitions"
    df -h

    echo ""
    echo "[STEP 8] Permanent mount (fstab)"

    read -p "  Make permanent? (y/n): " PERM

    if [ "$PERM" == "y" ]; then
      echo "Command: blkid"
      blkid

      UUID=$(blkid -s UUID -o value $PART)

      echo "Adding entry to /etc/fstab"
      echo "UUID=$UUID $MP $FS defaults 0 0" >> /etc/fstab

      echo "Command: systemctl daemon-reload"
      systemctl daemon-reload

      echo "Command: mount -a"
      mount -a

      echo "[VERIFY]"
      df -h
    fi
  fi
fi

# Unmount
echo ""
echo "[STEP 9] Unmount option"
read -p "  Do you want to unmount? (y/n): " UM

if [ "$UM" == "y" ]; then
  read -p "  Enter mount point: " UMP
  echo "Command: umount $UMP"
  umount $UMP
fi

# Delete partition
echo ""
echo "[STEP 10] Delete partition"
read -p "  Do you want to delete partition? (y/n): " DEL

if [ "$DEL" == "y" ]; then
  echo "Command: fdisk $DISK"
  echo "Deleting partition..."

  fdisk $DISK <<EOF
d

w
EOF

  echo "Command: partprobe"
  partprobe

  echo "[VERIFY]"
  lsblk
fi

echo ""
echo "======================================"
echo " Completed + Learned Successfully"
echo "======================================"