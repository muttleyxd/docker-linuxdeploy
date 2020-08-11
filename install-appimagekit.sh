#!/bin/bash

set -ex

source /entrypoint.sh

git clone --recursive https://github.com/AppImage/AppImageKit --depth=1 /tmp/AppImageKit
cd /tmp/AppImageKit

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release
make -j`nproc`
make install


{ # Test
  appimagetool --help
} &>/dev/null

rm -rf /tmp/AppImageKit
