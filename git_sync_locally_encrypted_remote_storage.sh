#! /bin/bash
# make a backup of my home directory on the raspberripi at pcextreme in the Netherlands box by pushing the git repo.
# Ideas from:
# http://www.linuxquestions.org/questions/linux-newbie-8/remote-encrypted-unattended-file-server-650280/
# http://www.vectorspace.dk/2009/06/encrypted-partition-on-debian-5-0-with-secret-key-on-usb-stick/
# http://www.vidarholen.net/contents/blog/?p=8

set -e

# the following environment variables must be set prior to calling this script:
#extHOST=
#extPath=
#extImgName=
#extUser=
#imageSize=
#loopDevice=

sh ./open_locally_encrypted_remote_storage.sh 


if [ ! -d /tmp/${extHOST}_hd/C/${extImgName}.git ]; then
	sudo mkdir -p /tmp/${extHOST}_hd/C/${extImgName}.git
	sudo chown ${extUser} /tmp/${extHOST}_hd/C/${extImgName}.git
	(cd /tmp/${extHOST}_hd/C/${extImgName}.git; git init --bare)
else
	git pull /tmp/${extHOST}_hd/C/${extImgName}.git master
fi

git push /tmp/${extHOST}_hd/C/${extImgName}.git master

read -p "Press [enter] to close the storage again ..."

sh ./close_locally_encrypted_remote_storage.sh 

