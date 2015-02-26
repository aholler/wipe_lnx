#!/bin/sh -e

MOUNTDIR="$(mktemp -d --tmpdir btrfs_mnt.XXXXXXXXXX)"
TESTIMG="$(mktemp --tmpdir btrfs_img.XXXXXXXXXX)"

dd if=/dev/zero of=$TESTIMG bs=1M count=20
#dd if=/dev/zero of=$TESTIMG bs=1M count=1024 # use this to test without mixed-bg
mkfs.btrfs $TESTIMG
grep -v --null-data -a abrakadabra $TESTIMG >/dev/null
mount -o loop,discard $TESTIMG $MOUNTDIR
echo abrakadabra >$MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -a --null-data abrakadabra $TESTIMG
mount -o loop,discard $TESTIMG $MOUNTDIR
rm $MOUNTDIR/foo.txt
umount $MOUNTDIR
grep -a --null-data abrakadabra $TESTIMG
rm $TESTIMG
rmdir $MOUNTDIR
echo "discard leak detected."
