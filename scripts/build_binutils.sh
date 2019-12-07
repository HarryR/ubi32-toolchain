#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils
BLD=$TOP/build
INSTALL=$TOP/release
INSTALL=$TOP/install
LOG=$TOP/log
PROG=binutils
TARGET=ubi32-none-elf
PREFIX=ubi32-elf
DATE=$(date +%Y-%m-%d)

PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi

echo " "
echo "======================="
echo " "
echo "Building Binutils"
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
echo " "

rm -f $LOG/$PROG-*.log

echo -n "  Configuring binutils"
$SRC/configure --prefix $INSTALL	\
	--target=$TARGET		\
	--program-prefix=$PREFIX-	\
	--with-pkgversion="$DATE" 	\
	--disable-werror		\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building binutils"
make -j4 "CFLAGS=$CFLAGS" all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing binutils"
make -j4 "CFLAGS=$CFLAGS" install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

# Rename target directory
#rm -rf $INSTALL/ubicom32-elf
#cp -r $INSTALL/ubi32-elf-gnu $INSTALL/ubicom32-elf

touch $BLD/$PROG/.build_complete

echo " "
echo -n "  Binutils done: "
date
