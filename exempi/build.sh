#!/bin/bash

export CXXFLAGS="-I$PREFIX/include"
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

chmod 755 configure
./configure \
    --prefix=$PREFIX \
    --with-boost=$PREFIX/include

make
make install
