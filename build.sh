#!/bin/sh

set -e -o pipefail

BORG_VERSION=$(./borg-version.sh)
echo "${BORG_VERSION}" > version.txt

IMAGE_VERSION="${BORG_VERSION}"

export ARG_BORG_VERSION="${BORG_VERSION}"
export TAG="${IMAGE_VERSION}"

if [ "$FORCE" != "1" ]; then
  echo Exit if "tgbyte/borg-backup:${IMAGE_VERSION}" already exists
  check-tag.sh "tgbyte/borg-backup:${IMAGE_VERSION}" && exit 0
fi

echo Building version "${BORG_VERSION}"

build-image.sh
