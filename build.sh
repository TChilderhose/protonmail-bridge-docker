#!/bin/bash

set -ex

VERSION=v3.1.2

git clone https://github.com/ProtonMail/proton-bridge.git
cd proton-bridge
git checkout $VERSION

# Build
make build-nogui
