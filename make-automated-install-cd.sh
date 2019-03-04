#!/bin/bash

# edit these 3 variables if you want to try another distro. create an md5sum
# file with something like 
#   md5sum $ISO > $ISO.MD5SUM
# P.S.: Not working with live-server image !!!
ISO=ubuntu-18.04.2-server-amd64.iso
OUTPUT=autoinstall-ubuntu-18.04.2-server-amd64.iso
URL=http://releases.ubuntu.com/18.04.2/ubuntu-18.04.2-server-amd64.iso

MOUNT=iso-mount-dir
WORK=iso-work-dir

# if we don't have iso or it doesnt' match md5sum, fetch it
if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
then
    rm -f $ISO
	wget $URL
    # if we still don't gots it, die
    if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
    then
        echo "Could not download iso?"
        exit 1
    fi
fi

# clean up after interruptted runs.  if this fails, it's because the mount
# point is still mounted, so manually unmount please.
rm -rf $MOUNT $WORK

# make mount point, mount it with sudo, copy over contents because ISO's
# can only be mounted readonly
mkdir -p $MOUNT $WORK
sudo mount -o ro,loop $ISO $MOUNT
cp -rT $MOUNT $WORK
chmod -R a+w $WORK

# copy files over to image
cp ks.cfg $WORK/
cp txt.cfg $WORK/isolinux/
cp isolinux.cfg $WORK/isolinux/

# magic mkiso incantation
mkisofs -D -r -V “AUTOINSTALL” -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $OUTPUT $WORK

# clean up after ourselves
sudo umount $MOUNT
rm -rf $MOUNT $WORK