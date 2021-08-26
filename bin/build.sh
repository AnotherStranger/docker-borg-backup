#!/bin/bash

set -e -o pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

BORG_VERSION=$(cat .version)
IMAGE_VERSION="${BORG_VERSION}"

export ARG_BORG_VERSION="${BORG_VERSION}"
export TAG="${IMAGE_VERSION}"

if [ -e .trivy-vulnerable ]; then
  VULNERABLE="1"
fi

if [ "$FORCE" != "1" ] && [ -z "$VULNERABLE" ]; then
  echo Exit if "tgbyte/borg-backup:${IMAGE_VERSION}" already exists
  check-tag.sh "tgbyte/borg-backup:${IMAGE_VERSION}" && exit 0
fi

echo Building version "${BORG_VERSION}"

build-image.sh
