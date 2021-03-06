#! /bin/bash
# sync the current git repository on the examplehost.

export extHOST=examplehost
export extPath=/var/www/exampleuser/
export extImgName=home
export extUser=exampleuser
export imageSize=1024 #1024MB = 1GB
export loopDevice=$(losetup -f)

PATH=$PATH:~/sourcecode/locally_encrypted_remote_storage

open_locally_encrypted_remote_storage.sh || { close_locally_encrypted_remote_storage.sh; exit 1; }
git_sync_locally_encrypted_remote_storage.sh

read -p "Press [enter] to close the storage again ..."

close_locally_encrypted_remote_storage.sh

