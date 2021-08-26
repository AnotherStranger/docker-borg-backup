#!/bin/bash

set -e -o pipefail

curl -s "https://api.github.com/repos/borgbackup/borg/tags" \
| jq -r '.[].name' \
| grep -v '[a-zA-z]' \
| sort -V \
| tail -1
