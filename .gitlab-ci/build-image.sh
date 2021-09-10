#!/bin/bash

source /usr/local/share/build-functions.sh

exit_if_image_present

export ARG_BORG_VERSION="${VERSION}"
build-image.sh
