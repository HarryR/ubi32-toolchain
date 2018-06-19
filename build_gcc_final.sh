#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/gcc
BLD=$TOP/build
INSTALL=$TOP/install
LOG=$TOP/log
PROG=gcc
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
echo "Building final GCC"
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

CFLAGS="-O2 -g3"
CXXFLAGS="-O2 -g3"
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

rm -f $LOG/$PROG-*.log

# FIXME -- Enable libssp
echo -n "  Configuring gcc final"
$SRC/configure --prefix $INSTALL	\
	--target=$TARGET		\
	--program-prefix=$PREFIX-	\
	--enable-languages=c		\
	--enable-plugins		\
	--disable-libssp		\
	--enable-install-libbfd 	\
	--enable-multilib		\
	--disable-decimal-float		\
	--disable-libmudflap 		\
	--disable-threads 		\
	--disable-libquadmath 		\
	--disable-libgomp 		\
	--disable-tls 			\
	--without-isl 			\
	--without-cloog 		\
	--disable-decimal-float 	\
	--with-headers 			\
	--with-newlib			\
	--disable-nls 			\
	--enable-checking=yes		\
	--with-system-zlib		\
	--with-pkgversion="$DATE" 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building gcc final"
make -j4 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing gcc final"
make -j4 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

touch $BLD/$PROG/.build_complete

echo " "
echo -n "  GCC final done: "
date
