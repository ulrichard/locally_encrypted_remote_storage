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

keyDir=~/.locally_encrypted_remote_storage
mkdir -p ${keyDir}

if [ ! -e /tmp/${extHOST}_hd/A/${extImgName}.img ]; then
	# prepare the disk image on the remote machine
	ssh ${extUser}@${extHOST} "(dd if=/dev/urandom of=${extPath}/${extImgName}.img bs=1M count=${imageSize}; chmod 700 ${extPath}/${extImgName}.img)"
	sudo modprobe dm-crypt
#	sudo modprobe aes
#	sudo modprobe sha256
	# prepare a key file and encrypt it
	dd if=/dev/urandom | tr -d '\n' | dd bs=1 count=64 of=${keyDir}/key_${extHOST}_${extImgName}.txt
	gpg -e ${keyDir}/key_${extHOST}_${extImgName}.txt
	git add ${keyDir}/key_${extHOST}_${extImgName}.txt.gpg
	sudo cryptsetup -c aes-xts-plain -s 512 luksFormat /tmp/${extHOST}_hd/A/${extImgName}.img ${keyDir}/key_${extHOST}_${extImgName}.txt
	
	sudo losetup ${loopDevice} /tmp/${extHOST}_hd/A/${extImgName}.img

	sudo cryptsetup luksOpen ${loopDevice} ${extHOST} < ${keyDir}/key_${extHOST}_${extImgName}.txt

	sudo mke2fs /dev/mapper/${extHOST}
else
	sudo losetup ${loopDevice} /tmp/${extHOST}_hd/A/${extImgName}.img

	gpg -d ${keyDir}/key_${extHOST}_${extImgName}.txt.gpg > ${keyDir}/key_${extHOST}_${extImgName}.txt || true
    sleep 1
	sudo cryptsetup luksOpen ${loopDevice} ${extHOST} < ${keyDir}/key_${extHOST}_${extImgName}.txt
fi

shred -u ${keyDir}/key_${extHOST}_${extImgName}.txt

sudo mkdir -p /tmp/${extHOST}_hd/C
sudo chmod 700 /tmp/${extHOST}_hd/C
sudo mount /dev/mapper/${extHOST} /tmp/${extHOST}_hd/C
echo "the locally encrypted remote storage is now mounted at /tmp/${extHOST}_hd/C"


