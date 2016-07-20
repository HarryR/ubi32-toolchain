#!/bin/bash

PWD=`pwd`
BUILD=$PWD/build/qemu
SOURCE=$PWD/src/qemu
INSTALL=$PWD/install
LOG=$PWD/build/qemu/log

GCCPATH=/opt/gnu/bin
PATH=$GCCPATH:/usr/local/bin:/usr/bin:/bin

TARGET_LIST="ubicom32-softmmu ubicom32el-softmmu"

rm -rf $BUILD $LOG

mkdir -p $BUILD $LOG

echo " "
echo "======================="
echo " "
echo "  Building QEMU"
echo " "
echo "  SOURCE=$SOURCE"
echo "  INSTALL=$INSTALL"
echo "  LOG=$LOG"
echo " "
echo -n "  "
date
echo " "
echo "  Configuring QEMU"
cd $BUILD
$SOURCE/configure --prefix=$INSTALL 			\
		  --disable-curl 			\
		  --disable-vnc-tls 			\
		  --disable-pie				\
		  --enable-debug			\
		  --sysroot=/home/eager/gnu/opensuse-11.2-64-sysroot	\
		  --target-list="$TARGET_LIST" 		\
			> $LOG/configure.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Building QEMU"
make V=1 CFLAGS=-g > $LOG/build.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo "  Installing QEMU"
make V=1 CFLAGS=-g install > $LOG/install.log 2>&1
rc=$?
if [ $rc -ne 0 ]; then echo "rc = $rc"; exit 1; fi

echo " "
echo "  QEMU build completed"
echo -n "  "
date
echo " "
echo "======================="
