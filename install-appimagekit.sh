#!/bin/bash

set -ex

source /entrypoint.sh

git clone --recursive https://github.com/AppImage/AppImageKit /tmp/AppImageKit
cd /tmp/AppImageKit
git checkout a2d9cfcb8f662ff8aad5122ce57f2d1898c25980

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release
make -j`nproc`
make install


{ # Test
  appimagetool --help
} &>/dev/null

rm -rf /tmp/AppImageKit
