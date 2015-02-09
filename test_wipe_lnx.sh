#!/bin/sh -e

FS=ext4
#FS=vfat
#FS=ext3 # needs CONFIG_EXT4_USE_FOR_EXT23=y
#FS=ext2 # needs CONFIG_EXT4_USE_FOR_EXT23=y

if [ "$(whoami)" != "root" ]; then
	echo "Need root"
	exit 1
fi

MOUNTDIR="$(mktemp -d --tmpdir wipe_lnx_mnt.XXXXXXXXXX)"
TESTIMG="$(mktemp --tmpdir wipe_lnx_img.XXXXXXXXXX)"

dd if=/dev/zero of=$TESTIMG bs=1M count=20
mkfs.$FS $TESTIMG
grep -v -a abrakadabra $TESTIMG >/dev/null
mount -o loop $TESTIMG $MOUNTDIR
echo abrakadabra >$MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -a abrakadabra $TESTIMG >/dev/null
mount -o loop $TESTIMG $MOUNTDIR
./wipe_lnx $MOUNTDIR/foo.txt
#rm -w $MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -v -a abrakadabra $TESTIMG >/dev/null
mount -o loop $TESTIMG $MOUNTDIR
echo abrakadabra >$MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -a abrakadabra $TESTIMG >/dev/null
mount -o loop $TESTIMG $MOUNTDIR
rm $MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -a abrakadabra $TESTIMG >/dev/null
rm $TESTIMG
rmdir $MOUNTDIR
echo "unlinkat(AT_WIPE) worked while unlink() didn't."
