#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils-gdb
BLD=$TOP/build
INST=$TOP/install
LOG=$TOP/log
PROG=gdb
TARGET=ubi32-elf-gnu
NAME=ubi32-elf
PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi
DATE=$(date +%Y-%m-%d)


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

echo -n "Configuring gdb"
$SRC/configure --prefix $INST		\
	--with-pkgversion="$DATE" 	\
	--target=$TARGET		\
	--program-prefix=ubi32-elf-	\
	--with-python=auto		\
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
