#!/bin/bash

set -ex

VERSION=v3.0.21

git clone https://github.com/ProtonMail/proton-bridge.git
cd proton-bridge
git checkout $VERSION

# Build
make build-nogui
