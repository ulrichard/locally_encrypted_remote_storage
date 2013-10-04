#! /bin/bash
# make sync the home git repository on the examplehost.

set -e

export extHOST=examplehost
export extPath=/var/www/exampleuser/
export extImgName=home
export extUser=exampleuser
export imageSize=1024 #1024MB = 1GB
export loopDevice=loop6


~/sourcecode/locally_encrypted_remote_storage/open_locally_encrypted_remote_storage.sh
~/sourcecode/locally_encrypted_remote_storage/git_sync_locally_encrypted_remote_storage.sh

read -p "Press [enter] to close the storage again ..."

~/sourcecode/locally_encrypted_remote_storage/close_locally_encrypted_remote_storage.sh

