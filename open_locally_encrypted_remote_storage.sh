#! /bin/bash
# make a backup of my home directory on the raspberripi at pcextreme in the Netherlands box by pushing the git repo.
# Ideas from:
# http://www.linuxquestions.org/questions/linux-newbie-8/remote-encrypted-unattended-file-server-650280/
# http://www.vectorspace.dk/2009/06/encrypted-partition-on-debian-5-0-with-secret-key-on-usb-stick/
# http://www.vidarholen.net/contents/blog/?p=8

set -e

# the following environment variables must be exported prior to calling this script:
#extHOST=
#extPath=
#extImgName=
#extUser=
#imageSize=
#loopDevice=

mkdir -p /tmp/${extHOST}_hd/A
chmod 750 /tmp/${extHOST}_hd/A
sshfs ${extUser}@${extHOST}:${extPath} /tmp/${extHOST}_hd/A -o allow_root

if [ ! -e /tmp/${extHOST}_hd/A/${extImgName}.img ]; then
	# prepare the disk image on the remote machine
	ssh ${extUser}@${extHOST} "(dd if=/dev/urandom of=${extPath}/${extImgName}.img bs=1M count=${imageSize}; chmod 700 ${extPath}/${extImgName}.img)"
	sudo modprobe dm-crypt
#	sudo modprobe aes
#	sudo modprobe sha256
	# prepare a key file and encrypt it
	dd if=/dev/urandom | tr -d '\n' | dd bs=1 count=64 of=key_${extHOST}_${extImgName}.txt
	gpg -e key_${extHOST}_${extImgName}.txt
	sudo cryptsetup -c aes-xts-plain -s 512 luksFormat /tmp/${extHOST}_hd/A/${extImgName}.img key_${extHOST}_${extImgName}.txt
	
	sudo losetup /dev/${loopDevice} /tmp/${extHOST}_hd/A/${extImgName}.img

	sudo cryptsetup luksOpen /dev/${loopDevice} ${extHOST} < key_${extHOST}_${extImgName}.txt

	sudo mke2fs /dev/mapper/${extHOST}
else
	sudo losetup /dev/${loopDevice} /tmp/${extHOST}_hd/A/${extImgName}.img

	gpg -d key_${extHOST}_${extImgName}.txt.gpg > key_${extHOST}_${extImgName}.txt
	sudo cryptsetup luksOpen /dev/${loopDevice} ${extHOST} < key_${extHOST}_${extImgName}.txt
fi

shred key_${extHOST}_${extImgName}.txt
rm key_${extHOST}_${extImgName}.txt

sudo mkdir -p /tmp/${extHOST}_hd/C
sudo chmod 700 /tmp/${extHOST}_hd/C
sudo mount /dev/mapper/${extHOST} /tmp/${extHOST}_hd/C
echo "the locally encrypted remote storage is now mounted at /tmp/${extHOST}_hd/C"


