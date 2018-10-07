#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/gcc
BLD=$TOP/build
INSTALL=$TOP/install
LOG=$TOP/log
PROG=gcc_stage1
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
echo "Building stage 1 GCC"
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

rm -f $LOG/$PROG-*.log

echo -n "  Configuring gcc stage 1"
$SRC/configure --prefix $INSTALL	\
	--target=$TARGET		\
	--program-prefix=$PREFIX-	\
	--enable-languages=c 		\
	--enable-multilib		\
	--disable-decimal-float		\
	--disable-libssp 		\
	--disable-libsanitizer 		\
	--disable-tls 			\
	--disable-libmudflap 		\
	--disable-threads 		\
	--disable-libquadmath 		\
	--disable-libgomp 		\
	--without-isl 			\
	--without-cloog 		\
	--disable-decimal-float 	\
	--without-headers 		\
	--with-newlib			\
	--disable-largefile 		\
	--disable-nls 			\
	--enable-checking=yes		\
	--with-system-zlib		\
	--with-pkgversion="$DATE" 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building gcc stage 1"
make -j4 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing gcc stage 1"
make -j4 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

touch $BLD/$PROG/.build_complete

echo " "
echo -n "  GCC stage 1 done: "
date
