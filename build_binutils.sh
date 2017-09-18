#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils-gdb
BLD=$TOP/build
INST=$TOP/release
LOG=$TOP/log
PROG=binutils
TARGET=ubi32-elf-gnu
PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi
DATE=$(date +%Y-%m-%d)

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

rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG

rm -f $LOG/$PROG*.log

echo -n "Configuring binutils"
$SRC/configure --prefix $INST	\
	--target=$TARGET		\
	--program-prefix=ubicom32-elf-	\
	--with-pkgversion="$DATE" 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "Building binutils"
make all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "Installing binutils"
make install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

# Rename target directory
mv $INST/ubi32-elf-gnu $INST/ubicom32-elf

echo " "
echo -n "Finish: "
date
