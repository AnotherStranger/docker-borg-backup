#!/bin/bash

source /usr/local/share/build-functions.sh

exit_if_image_present

build-manifest.sh
TAG=latest build-manifest.sh
