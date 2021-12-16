#!/bin/bash

set -ex

VERSION=v2.0.1

git clone https://github.com/ProtonMail/proton-bridge.git

cd proton-bridge
git checkout $VERSION

git apply ../patches/*.patch

# Build
make build-nogui