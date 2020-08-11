#! /bin/bash

# Make sure that the pkgconfig configs are available
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig

# Favor /usr/local/lib over /lib and /usr/lib
export LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

exec "$@"
