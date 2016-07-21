#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils-gdb
BLD=$TOP/build
INST=$TOP/install
LOG=$TOP/log
PROG=gdb
TARGET=ubi32-elf-gnu
NAME=ubi32-elf
GCCPATH=/opt/gnu/bin
PATH=$GCCPATH:/usr/local/bin:/usr/bin:/bin
SYSROOT=/home/eager/gnu/opensuse-11.2-64-sysroot


echo " "
echo "Building GDB"
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

rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG

rm -f $LOG/$PROG*.log

#export LD_LIBRARY_PATH=$SYSROOT/usr/lib:$SYSROOT/usr/lib64

echo -n "Configuring gdb"
$SRC/configure --prefix $INST	\
	--target=$TARGET		\
	--program-prefix=ubi32-elf-	\
	--with-python=auto		\
	--with-sysroot=$SYSROOT 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "Building gdb"
make CFLAGS=-ggdb all-gdb >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "Installing gdb"
make install-gdb >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

echo " "
echo -n "Finish: "
date
