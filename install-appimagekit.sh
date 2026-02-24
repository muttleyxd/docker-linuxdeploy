#!/bin/bash

set -ex

source /entrypoint.sh

git clone --recursive https://github.com/AppImage/AppImageKit /tmp/AppImageKit
cd /tmp/AppImageKit
git checkout a2d9cfcb8f662ff8aad5122ce57f2d1898c25980
git submodule update --init --recursive

# Fix broken sourceforge mirror URL for xz
sed -i 's|netcologne.dl.sourceforge.net|downloads.sourceforge.net|g' lib/libappimage/cmake/dependencies.cmake

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make -j`nproc`
make install


{ # Test
  appimagetool --help
} &>/dev/null

rm -rf /tmp/AppImageKit
