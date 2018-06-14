#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/newlib
BLD=$TOP/build
INSTALL=$TOP/install
LOG=$TOP/log
PROG=newlib
TARGET=ubi32-none-elf
PREFIX=ubi32-elf
DATE=$(date +%Y-%m-%d)

PATH=/usr/local/bin:/usr/bin:/bin
if [ -n "$GCC_PATH" ] ; then
  PATH=$GCC_PATH:$PATH
fi
PATH=$INSTALL/bin:$PATH

echo " "
echo "======================="
echo " "
echo "Building NEWLIB"
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

export AR_FOR_TARGET=${PREFIX}-ar
export RANLIB_FOR_TARGET=${PREFIX}-ranlib
export AS_FOR_TARGET=${PREFIX}-as
export CC_FOR_TARGET=${PREFIX}-gcc
export CXX_FOR_TARGET=${PREFIX}-g++

CFLAGS="-O2 -g"
CXXFLAGS="-O2 -g"
if [ "x$1" == "xdebug" ]; then
  CFLAGS="-g"
  CXXFLAGS="-g"
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

#rm -rf $INSTALL
mkdir -p $INSTALL $LOG

echo "  Removing $BLD/$PROG"
rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG
echo " "

export CFLAGS_FOR_TARGET="-g -O0"
export CFLAGS_FOR_BUILD="-g -O0"

rm -f $LOG/$PROG-*.log

echo -n "  Configuring Newlib"
$SRC/configure --prefix $INSTALL	\
	--target=$TARGET		\
	--enable-multilib		\
	--disable-nls 			\
	--with-pkgversion="$DATE" 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building Newlib"
make -j4 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing Newlib"
make "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

touch $BLD/$PROG/.build_complete

echo " "
echo -n "Finish: "
date
