#! /bin/bash
# close the encrypted remote mount that was set up earlier with open_locally_encrypted_remote_storage.sh

# the following environment variables must be set prior to calling this script:
#extHOST=
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



