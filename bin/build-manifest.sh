#!/bin/bash

set -e -o pipefail

BORG_VERSION=$(cat .version)
IMAGE_VERSION="${BORG_VERSION}"
export TAG="${IMAGE_VERSION}"

if [ -e .trivy-vulnerable ]; then
  VULNERABLE="1"
fi

if [ "$FORCE" != "1" ] && [ -z "$VULNERABLE" ]; then
  echo Exit if "tgbyte/borg-backup:${IMAGE_VERSION}" already exists
  check-tag.sh "tgbyte/borg-backup:${IMAGE_VERSION}" && exit 0
fi

echo Building manifest for version "${BORG_VERSION}"

build-manifest.sh
TAG=latest build-manifest.sh
