#!/usr/bin/env bash

set -ex

source /entrypoint.sh

git clone https://github.com/linuxdeploy/linuxdeploy.git /tmp/linuxdeploy
pushd /tmp/linuxdeploy
git checkout 557bad2241df2c33972c7e6bdbf0c528cee27cc8

git submodule update --init --recursive

# Fix: wrap test targets in BUILD_TESTING check
cat > /tmp/linuxdeploy-fix-testing.patch << 'EOF'
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index d7bba6d..7790e28 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -54,11 +54,12 @@ target_compile_definitions(linuxdeploy PRIVATE -DLD_VERSION="${VERSION}")
 target_compile_definitions(linuxdeploy PRIVATE -DLD_BUILD_NUMBER="${BUILD_NUMBER}")
 target_compile_definitions(linuxdeploy PRIVATE -DLD_BUILD_DATE="${DATE}")

-add_executable(plugin_test plugin_test_main.cpp)
-target_link_libraries(plugin_test linuxdeploy_plugin)
-set_target_properties(plugin_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
-
-add_executable(appdir_test appdir_test_main.cpp)
-target_link_libraries(appdir_test linuxdeploy_core args)
-target_include_directories(appdir_test PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/core)
-set_target_properties(appdir_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
+if(BUILD_TESTING)
+    add_executable(plugin_test plugin_test_main.cpp)
+    target_link_libraries(plugin_test linuxdeploy_plugin)
+    set_target_properties(plugin_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
+
+    add_executable(appdir_test appdir_test_main.cpp)
+    target_link_libraries(appdir_test linuxdeploy_core args)
+    target_include_directories(appdir_test PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/core)
+    set_target_properties(appdir_test PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
+endif()
EOF
patch -p1 < /tmp/linuxdeploy-fix-testing.patch

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_CIMG=Off -DUSE_CCACHE=Off -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DBUILD_TESTING=OFF
make -j`nproc`

mv bin/linuxdeploy /usr/local/bin/linuxdeploy
popd

rm -rf /tmp/linuxdeploy