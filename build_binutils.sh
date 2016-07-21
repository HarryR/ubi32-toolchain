#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils-gdb
BLD=$TOP/build
INST=$TOP/install
LOG=$TOP/log
PROG=binutils
TARGET=ubi32-elf-gnu
GCCPATH=/opt/gnu/bin
PATH=$GCCPATH:/usr/local/bin:/usr/bin:/bin

echo " "
echo "Building Binutils"
echo "Target:  $TARGET"
echo "Source:  $SRC"
echo "Build:   $BLD"
echo "Install: $INST"
echo "Log:     $LOG"
echo "PATH:    $PATH"
echo " "
echo -n "Start: "
date

function check_rc
{
  if [ $1 == 0 ]; then
    echo " - OK"
  else
    echo " - FAILED (rc=$rc)"
    exit $rc
  fi
}

mkdir -p $INST $LOG

which rm
rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG

which rm
rm -f $LOG/$PROG*.log

echo -n "Configuring binutils"
$SRC/configure --prefix $INST	\
	--target=$TARGET		\
	--enable-cgen-maint		\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "Building binutils"
make all-binutils >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "Installing binutils"
make install-binutils >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

echo " "
echo -n "Finish: "
date
