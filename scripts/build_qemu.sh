#!/bin/bash

TOP=`pwd`
BLD=$TOP/build
SOURCE=$TOP/src/qemu
INSTALL=$TOP/install
LOG=$TOP/log
PROG=qemu
TARGET_LIST="ubicom32-softmmu,ubicom32el-softmmu"
DATE=$(date +%Y-%m-%d)

PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi

echo "  Removing $BLD/$PROG"
rm -rf $BLD/$PROG
rm -f $LOG/$PROG*.log

mkdir -p $BLD/$PROG $LOG

echo " "
echo "======================="
echo " "
echo "Building QEMU"
echo " "
date
echo " "
echo "Target:  $TARGET_LIST"
echo "Build:   $BLD"
echo "Install: $INSTALL"
echo "Log:     $LOG"
echo "PATH:    $PATH"
echo " "

CFLAGS="-O2 -g"
if [ "x$1" == "xdebug" ]; then
  CFLAGS="-g"
  echo "  Building debug version"
fi

cd $BLD/$PROG
echo "  Configuring QEMU"
$SOURCE/configure --prefix=$INSTALL 			\
		  --with-pkgversion="$DATE" 		\
		  --disable-curl 			\
		  --disable-vnc 			\
		  --disable-vnc-tls 			\
		  --disable-pie				\
		  --disable-sdl				\
		  --disable-virtfs			\
		  --disable-vnc				\
		  --disable-slirp			\
		  --disable-uuid			\
		  --disable-vde				\
		  --disable-spice			\
		  --disable-usb-redir			\
		  --disable-smartcard			\
		  --disable-seccomp			\
		  --enable-tlmu				\
		  --enable-archrefcompare		\
		  --enable-debug			\
		  --disable-strip			\
		  --sysroot=$SYSROOT			\
		  --target-list="$TARGET_LIST" 		\
			> $LOG/$PROG-configure.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Building QEMU"
make -j4 V=1 "CFLAGS=$CFLAGS" > $LOG/$PROG-build.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Installing QEMU"
make -j4 V=1 "CFLAGS=$CFLAGS" install > $LOG/$PROG-install.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

touch $BLD/$PROG/.build_complete

echo " "
echo -n "  QEMU done:  "
date
echo " "
