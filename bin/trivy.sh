#!/bin/sh

BORG_VERSION=$(cat .version)
IMAGE_VERSION="${BORG_VERSION}"

trivy \
  --cache-dir .trivy \
  image \
  --severity HIGH,CRITICAL \
  --ignore-unfixed \
  --exit-code 2 \
  --no-progress \
  "tgbyte/borg-backup:${IMAGE_VERSION}"
EXITCODE=$?

if [ $EXITCODE -eq 2 ]; then
  echo "Detected vulnerable Docker image tgbyte/borg-backup:${IMAGE_VERSION} - forcing rebuild"
  echo "1" > .trivy-vulnerable
fi

exit $EXITCODE
