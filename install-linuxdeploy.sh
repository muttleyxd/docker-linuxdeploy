#!/usr/bin/env bash

set -ex

source /entrypoint.sh

git clone https://github.com/linuxdeploy/linuxdeploy.git /tmp/linuxdeploy
pushd /tmp/linuxdeploy
git checkout 557bad2241df2c33972c7e6bdbf0c528cee27cc8

git submodule update --init --recursive

# Fix: add missing include directory for appdir_test
cat > /tmp/linuxdeploy-fix-include.patch << 'EOF'
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index d7bba6d..7790e28 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -58,6 +59,7 @@ set_target_properties(appdir_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
+target_include_directories(appdir_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/core/copyright)
EOF
patch -p1 < /tmp/linuxdeploy-fix-include.patch

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_CIMG=Off -DUSE_CCACHE=Off -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_TESTING=OFF
make -j`nproc`

mv bin/linuxdeploy /usr/local/bin/linuxdeploy
popd

rm -rf /tmp/linuxdeploy
