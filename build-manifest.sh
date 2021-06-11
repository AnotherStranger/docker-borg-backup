#!/bin/sh

set -e -o pipefail

BORG_VERSION=$(cat version.txt)
IMAGE_VERSION="${BORG_VERSION}"
export TAG="${IMAGE_VERSION}"

if [ "$FORCE" != "1" ]; then
  echo Exit if "tgbyte/borg-backup:${IMAGE_VERSION}" already exists
  check-tag.sh "tgbyte/borg-backup:${IMAGE_VERSION}" && exit 0
fi

echo Building manifest for version "${BORG_VERSION}"

build-manifest.sh
TAG=latest build-manifest.sh
