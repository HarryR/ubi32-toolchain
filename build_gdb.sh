#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/gdb
BLD=$TOP/build
INSTALL=$TOP/install
LOG=$TOP/log
PROG=gdb
TARGET=ubi32-none-elf
NAME=ubi32-elf
PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi
DATE=$(date +%Y-%m-%d)


echo " "
echo "======================="
echo " "
echo "Building GDB"
echo " "
date
echo " "
echo "Target:  $TARGET"
echo "Source:  $SRC"
echo "Build:   $BLD"
echo "Install: $INSTALL"
echo "Log:     $LOG"
echo "PATH:    $PATH"
echo " "
echo -n "Start: "

CFLAGS="-O2 -g"
if [ "x$1" == "xdebug" ]; then
  CFLAGS="-g"
  echo "  Building debug version"
fi

function check_rc
{
  if [ $1 == 0 ]; then
    echo " - OK"
  else
    echo " - FAILED (rc=$rc)"
    exit $rc
  fi
}

mkdir -p $INSTALL $LOG

echo "  Removing $BLD/$PROG"
rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG

rm -f $LOG/$PROG*.log

echo -n "  Configuring gdb"
$SRC/configure --prefix $INSTALL	\
	--with-pkgversion="$DATE" 	\
	--target=$TARGET		\
	--program-prefix=ubi32-elf-	\
	--with-python=auto		\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building gdb"
make -j4 CFLAGS=-ggdb all-gdb >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing gdb"
make -j4 install-gdb >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

touch $BLD/$PROG/.build_complete

echo " "
echo -n "  GDB done: "
date
