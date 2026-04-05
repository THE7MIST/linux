#!/bin/bash

echo "======================================"
echo " LVM Guided Practical Tool"
echo "======================================"

# STEP 1: Disk Selection
echo ""
echo "[STEP 1] View disks"
echo "Command: lsblk"
lsblk

read -p "👉 Enter disk (e.g. /dev/sdb): " DISK

echo ""
echo "[STEP 2] Create partitions (for PV)"
echo "We will create 2 partitions of 4GB each"

fdisk $DISK <<EOF
n
p
1

+4G
n
p
2

+4G
t
1
8e
t
2
8e
w
EOF

partprobe

echo "[VERIFY] Partitions:"
lsblk

# STEP 3: PV Creation
echo ""
echo "[STEP 3] Create Physical Volumes"
echo "Command: pvcreate ${DISK}1 ${DISK}2"
pvcreate ${DISK}1 ${DISK}2

echo "[VERIFY]"
pvs
pvdisplay

# STEP 4: VG Creation
echo ""
echo "[STEP 4] Create Volume Group vgdata"
echo "Command: vgcreate vgdata ${DISK}1 ${DISK}2"
vgcreate vgdata ${DISK}1 ${DISK}2

echo "[VERIFY]"
vgs
vgdisplay vgdata

# STEP 5: Custom VG
echo ""
echo "[STEP 5] Create partition for custom VG"

fdisk $DISK <<EOF
n
p
3

+2G
t
3
8e
w
EOF

partprobe

pvcreate ${DISK}3

echo "Command: vgcreate -s 16M vgcustom ${DISK}3"
vgcreate -s 16M vgcustom ${DISK}3

echo "[VERIFY]"
vgdisplay vgcustom

# STEP 6: LV Creation
echo ""
echo "[STEP 6] Create Logical Volumes"

echo "Creating lvsize (2G)"
lvcreate -L 2G -n lvsize vgdata

echo "Creating lvext (50%FREE)"
lvcreate -l 50%FREE -n lvext vgdata

echo "Creating lvcustom (100%FREE)"
lvcreate -l 100%FREE -n lvnext vgcustom

echo "[VERIFY]"
lvs
lvdisplay

# STEP 7: Formatting
echo ""
echo "[STEP 7] Format LVs (xfs)"
mkfs.xfs /dev/vgdata/lvsize
mkfs.xfs /dev/vgdata/lvext
mkfs.xfs /dev/vgcustom/lvnext

echo "[VERIFY]"
lsblk -f

# STEP 8: Mounting
echo ""
echo "[STEP 8] Mount Logical Volumes"

mkdir -p /mnt/data1 /mnt/data2 /mnt/backup

mount /dev/vgdata/lvsize /mnt/data1
mount /dev/vgcustom/lvnext /mnt/data2

echo "[VERIFY]"
df -h

# STEP 9: Permanent Mount
echo ""
echo "[STEP 9] Permanent mount setup"

blkid

UUID=$(blkid -s UUID -o value /dev/vgcustom/lvnext)

echo "Adding to /etc/fstab"
echo "UUID=$UUID /mnt/backup xfs defaults 0 0" >> /etc/fstab

systemctl daemon-reload
mount -a

echo "[VERIFY]"
df -h

# STEP 10: Extend LV
echo ""
echo "[STEP 10] Extend lvsize by 1G"

lvextend -L +1G /dev/vgdata/lvsize
xfs_growfs /mnt/data1

echo "[VERIFY]"
df -h

# STEP 11: Reduce LV (safe method)
echo ""
echo "[STEP 11] Reduce lvext"

umount /dev/vgdata/lvext
lvreduce -L 1.5G /dev/vgdata/lvext
mkfs.xfs -f /dev/vgdata/lvext
mount /dev/vgdata/lvext /mnt/data2

echo "[VERIFY]"
df -h

# STEP 12: Cleanup
echo ""
echo "[STEP 12] Cleanup"

umount /mnt/data1
umount /mnt/data2
umount /mnt/backup

echo "Removing fstab entry (manual step recommended)"

lvremove /dev/vgdata/lvsize -y
lvremove /dev/vgdata/lvext -y
lvremove /dev/vgcustom/lvnext -y

vgremove vgdata
vgremove vgcustom

pvremove ${DISK}1 ${DISK}2 ${DISK}3

fdisk $DISK <<EOF
d

d

d

w
EOF

partprobe

echo "[FINAL VERIFY]"
lsblk

echo ""
echo "======================================"
echo " LVM Practical Completed"
echo "======================================"