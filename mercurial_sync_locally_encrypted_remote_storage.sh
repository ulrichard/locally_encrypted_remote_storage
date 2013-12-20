#! /bin/bash
# synchronize a mercurial repository

set -e

# the following environment variables must be set prior to calling this script:
#extHOST=
#extPath=
#extImgName=
#extUser=
#imageSize=
#loopDevice=


if [ ! -d /tmp/${extHOST}_hd/C/${extImgName}.hg ]; then
	sudo mkdir -p /tmp/${extHOST}_hd/C/${extImgName}.hg
	sudo chown ${USER} /tmp/${extHOST}_hd/C/${extImgName}.hg
	(cd /tmp/${extHOST}_hd/C/${extImgName}.hg; hg init )
else
	hg pull /tmp/${extHOST}_hd/C/${extImgName}.hg 
fi

hg push --new-branch -f /tmp/${extHOST}_hd/C/${extImgName}.hg


