#!/bin/bash

PWD=`pwd`
BUILD=$PWD/build/qemu
SOURCE=$PWD/src/qemu
INSTALL=$PWD/install
LOG=$PWD/log
PROG=qemu
DATE=$(date +%Y-%m-%d)

PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi

TARGET_LIST="arm-softmmu"
TARGET_LIST+=",ubicom32-softmmu,ubicom32el-softmmu"

mkdir -p $BUILD $LOG

rm -f $LOG/$PROG*.log

echo " "
echo "======================="
echo " "
echo "  Building QEMU"
echo " "
echo "  SOURCE=$SOURCE"
echo "  INSTALL=$INSTALL"
echo "  PATH=$PATH"
echo "  LOG=$LOG"
echo " "
echo -n "  "
date
echo " "
echo "  Configuring QEMU"
cd $BUILD
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
		  --enable-debug			\
		  --disable-strip			\
		  --enable-tlmu				\
		  --enable-archrefcompare		\
		  --sysroot=$SYSROOT			\
		  --target-list="$TARGET_LIST" 		\
			> $LOG/$PROG-configure.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Building QEMU"
make V=1 CFLAGS=-g > $LOG/$PROG-build.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Installing QEMU"
make V=1 CFLAGS=-g install > $LOG/$PROG-install.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo " "
echo "  QEMU build completed"
echo -n "  "
date
echo " "
echo "======================="
