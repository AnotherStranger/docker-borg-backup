#!/bin/bash
set -euxo pipefail

# This file povides a simple smoketest for the build borg binary within the container image
# In this file, we first try to print the borg version, then we try to create a repo and verify its existence.
# In the last step we try to backup a single file.

# Error handling function
error_handler() {
    echo "There was an error while performing the self test."
    exit 1
}
trap 'error_handler' ERR


export BORG_REPO=/home/borg/backups/test-repo
export BORG_PASSPHRASE="test"

# Print version
borg version

# Initialize a BorgBackup repository
borg repo-create --encryption=repokey-aes-ocb

# Check that the repository was created successfully
borg repo-list

# backup single file and try to restore it.
echo "Hello, World!" > testfile.txt
borg create ::test ./testfile.txt

# restore backup
mkdir restored
cd restored
borg extract ::test

# Compare file with original
cmp -s ../testfile.txt ./testfile.txt || exit 1

echo "Selftest finished without errors."
