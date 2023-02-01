#!/bin/bash

set -ex

VERSION=v3.0.12

git clone https://github.com/ProtonMail/proton-bridge.git
cd proton-bridge
git checkout $VERSION

#git apply --ignore-whitespace ../patches/*.patch

# Build
make build-nogui
