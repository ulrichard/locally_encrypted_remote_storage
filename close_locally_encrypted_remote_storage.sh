#! /bin/bash
# make a backup on an external box.
# Ideas from:
# http://www.linuxquestions.org/questions/linux-newbie-8/remote-encrypted-unattended-file-server-650280/
# http://www.vectorspace.dk/2009/06/encrypted-partition-on-debian-5-0-with-secret-key-on-usb-stick/
# http://www.vidarholen.net/contents/blog/?p=8

#set -e

# the following environment variables must be set prior to calling this script:
#extHOST=
#extPath=
#extImgName=
#extUser=
#imageSize=
#loopDevice=


sudo sync
sudo umount /tmp/${extHOST}_hd/C
sudo cryptsetup luksClose  ${extHOST}
sudo losetup -d ${loopDevice}
sleep 1
sudo umount /tmp/${extHOST}_hd/A
sudo rm -d /tmp/${extHOST}_hd/C
sudo rm -d /tmp/${extHOST}_hd/A
sudo rm -d /tmp/${extHOST}_hd



