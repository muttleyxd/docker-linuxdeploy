#!/usr/bin/env bash

set -ex

source /entrypoint.sh

git clone https://github.com/linuxdeploy/linuxdeploy.git /tmp/linuxdeploy
pushd /tmp/linuxdeploy
git checkout 557bad2241df2c33972c7e6bdbf0c528cee27cc8

git submodule update --init --recursive
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_CIMG=Off -DUSE_CCACHE=Off
make -j`nproc`

mv bin/linuxdeploy /usr/local/bin/linuxdeploy
popd

rm -rf /tmp/linuxdeploy