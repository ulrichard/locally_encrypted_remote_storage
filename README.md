locally_encrypted_remote_storage
================================

scripts to locally mount a luks encrypted volume stored on an untrusted remote server.
You need to have ssh access to the remote host, keybased if possible. 
It is also advisable that you have gpg agent running, and your private keys on a smart card.
The scripts in this directory are meant to be called from your own scripts.
Your scripts has to previously export a set of environment variables mentioned in the scripts.

example_sync_git_home.sh  is an example of how the scripts can be used.

* scripts to open and close (i.e. mount and unmount) the storage
open_locally_encrypted_remote_storage.sh 
close_locally_encrypted_remote_storage.sh 

* scripts to synchronize (e.g. pull and push) a repository or directory
git_sync_locally_encrypted_remote_storage.sh
mercurial_sync_locally_encrypted_remote_storage.sh
rsync_locally_encrypted_remote_storage.sh

