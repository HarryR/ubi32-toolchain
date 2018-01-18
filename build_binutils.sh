#!/bin/bash

TOP=`pwd`
SRC=$TOP/src/binutils
BLD=$TOP/build
INST=$TOP/release
LOG=$TOP/log
PROG=binutils
TARGET=ubi32-elf-gnu
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
echo "Install: $INST"
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

#rm -rf $INST
mkdir -p $INST $LOG

echo "  Removing $BLD/$PROB"
rm -rf  $BLD/$PROG
mkdir -p $BLD/$PROG
cd $BLD/$PROG
echo " "

rm -f $LOG/$PROG*.log

echo -n "  Configuring binutils"
$SRC/configure --prefix $INST	\
	--target=$TARGET		\
	--program-prefix=ubicom32-elf-	\
	--with-pkgversion="$DATE" 	\
	>& $LOG/$PROG-configure.log
rc=$?
check_rc $rc

echo -n "  Building binutils"
make "CFLAGS=$CFLAGS" all >& $LOG/$PROG-make.log
rc=$?
check_rc $rc

echo -n "  Installing binutils"
make "CFLAGS=$CFLAGS" install >& $LOG/$PROG-install.log
rc=$?
check_rc $rc

# Rename target directory
rm -rf $INST/ubicom32-elf
cp -r $INST/ubi32-elf-gnu $INST/ubicom32-elf

echo " "
echo -n "Finish: "
date
