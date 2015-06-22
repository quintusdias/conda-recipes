#!/bin/bash

mkdir -vp ${PREFIX}/bin;

ARCH="$(uname 2>/dev/null)"

#export CXXFLAGS="${CFLAGS}"
export CPPFLAGS="-I${PREFIX}/include"
export LDFLAGS="-L${PREFIX}/lib"
export LD_FALLBACK_LIBRARY_PATH="-L${PREFIX}/lib"

MacInstallation() {

    chmod +x configure;

    ./configure \
        --enable-shared \
        --disable-static \
        --enable-netcdf=no \
        --enable-fortran=no \
		--without-szlib \
        --prefix=${PREFIX} || return 1;
    make || return 1;
    make check return 1;
    make install || return 1;

    rm -rf ${PREFIX}/share/hdf4_examples;

    return 0;
}

LinuxInstallation() {

    export CFLAGS="-m64 -pipe -O2 -march=x86-64 -fPIC"

    chmod +x configure;

    ./configure \
        --disable-static \
        --enable-linux-lfs \
        --enable-netcdf=no \
        --enable-fortran=no \
        --prefix=${PREFIX} || return 1;
    make || return 1;
    make install || return 1;

    rm -rf ${PREFIX}/share/hdf4_examples;

    return 0;
}

case ${ARCH} in
    'Linux')
        LinuxInstallation || exit 1;
        ;;

    'Darwin')
        MacInstallation || exit 1;
        ;;
    *)
        echo -e "Unsupported machine type: ${ARCH}";
        exit 1;
        ;;
esac

#POST_LINK="${PREFIX}/bin/.hdf4-post-link.sh"
#cp -v ${RECIPE_DIR}/post-link.sh ${POST_LINK};
#chmod -v 0755 ${POST_LINK};
