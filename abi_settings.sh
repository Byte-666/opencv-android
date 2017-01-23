#!/bin/bash

# $1 = architecture
# $2 = base directory
# $3 = pass 1 if you want to export default compiler environment variables

. settings.sh

BASEDIR=$2

case $1 in
  armeabi)
    NDK_ABI='arm'
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="arm-linux-androideabi"
  ;;
  armeabi-v7a)
    NDK_ABI='arm'
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="arm-linux-androideabi"
  ;;
  armeabi-v7a-neon)
    NDK_ABI='arm'
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="arm-linux-androideabi"
    CFLAGS="${CFLAGS} -mfpu=neon"
  ;;
  arm64-v8a)
    NDK_ABI='aarch64'
    NDK_TOOLCHAIN_ABI='aarch64-linux-android'
    NDK_CROSS_PREFIX="aarch64-linux-android"
    CFLAGS="${CFLAGS}"
    ANDROID_API_VERSION=21
  ;;
  x86)
    NDK_ABI='x86'
    NDK_TOOLCHAIN_ABI='x86-linux-android'
    NDK_CROSS_PREFIX="i686-linux-android"
    CFLAGS="${CFLAGS} -march=i686"
  ;;
  x86_64)
    NDK_ABI='x86_64'
    NDK_TOOLCHAIN_ABI='x86_64-linux-android'
    NDK_CROSS_PREFIX="x86_64-linux-android"
    CFLAGS="${CFLAGS}"
    ANDROID_API_VERSION=21
  ;;
esac

TOOLCHAIN_PREFIX=${BASEDIR}/toolchain-android-$1
if [ ! -d "${TOOLCHAIN_PREFIX}" ]; then
  ${ANDROID_NDK_ROOT_PATH}/build/tools/make-standalone-toolchain.sh --toolchain=${NDK_TOOLCHAIN_ABI}-${NDK_TOOLCHAIN_ABI_VERSION} --platform=android-${ANDROID_API_VERSION} --install-dir=${TOOLCHAIN_PREFIX}
fi

export ANDROID_EXECUTABLE="${ANDROID_SDK}/tools/android.bat"

export CROSS_BIN=${TOOLCHAIN_PREFIX}/bin/
export CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/${NDK_CROSS_PREFIX}-
export NDK_SYSROOT="${TOOLCHAIN_PREFIX}/sysroot"
export LD_LIBRARY_PATH="${TOOLCHAIN_PREFIX}/lib"
export PKG_CONFIG_LIBDIR="${TOOLCHAIN_PREFIX}/lib/pkgconfig"
export PKG_CONFIG_PATH="${TOOLCHAIN_PREFIX}/lib/pkgconfig"

if [ $3 == 1 ]; then
  export CC="${CROSS_PREFIX}clang"
  export CFLAGS="--sysroot=${NDK_SYSROOT}"
  export CXX="${CROSS_PREFIX}clang++"
  export CXXFLAGS="--sysroot=${NDK_SYSROOT}"
  export CPP="${CROSS_PREFIX}clang -E "
  export AR="${CROSS_PREFIX}ar"
  export AS="${CROSS_PREFIX}clang -mllvm --x86-asm-syntax=intel "
  export LD="${CROSS_PREFIX}clang"
  export RANLIB="${CROSS_PREFIX}ranlib"
  export STRIP="${CROSS_PREFIX}strip"
  export READELF="${CROSS_PREFIX}readelf"
  export OBJDUMP="${CROSS_PREFIX}objdump"
  export ADDR2LINE="${CROSS_PREFIX}addr2line"
  export OBJCOPY="${CROSS_PREFIX}objcopy"
  export ELFEDIT="${CROSS_PREFIX}elfedit"
  export DWP="${CROSS_PREFIX}dwp"
  export GCONV="${CROSS_PREFIX}gconv"
  export GDP="${CROSS_PREFIX}gdb"
  export GPROF="${CROSS_PREFIX}gprof"
  export NM="${CROSS_PREFIX}nm"
  export SIZE="${CROSS_PREFIX}size"
  export STRINGS="${CROSS_PREFIX}strings"
  export YASMEXE="${CROSS_BIN}yasm"
  export MAKE="${CROSS_BIN}make"
fi
