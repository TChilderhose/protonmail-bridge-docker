#!/bin/bash

set -ex

VERSION=`cat VERSION`

# Clone new code
git clone https://github.com/ProtonMail/proton-bridge.git
cd proton-bridge
git checkout v$VERSION
git apply ../*.patch #patches get copied to the root folder from the ./patches folder on build

# Build
make build-nogui