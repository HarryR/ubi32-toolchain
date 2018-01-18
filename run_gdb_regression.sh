#!/bin/bash

TEST=${1:--directory=gdb.base}

ROOTDIR=`pwd`
TOOLDIR=$ROOTDIR/../ubicom32-toolchain
DATE=$(date +%Y-%m-%d-%H-%M)
SRCDIR=$ROOTDIR/src
BLDDIR=$ROOTDIR/build
GDB=$BLDDIR/gdb
RELDIR=$TOOLDIR/release
QEMUDIR=$ROOTDIR/install
DEJADIR=$TOOLDIR/src/dejagnu
PATH=$RELDIR/bin:$QEMUDIR/bin:$DEJADIR:$PATH
RESULTSDIR=$ROOTDIR/results
RESULTS=$RESULTSDIR/gdb/$DATE

export DEJAGNULIBS=$TOOLDIR/src/dejagnu

if [ ! -d $GDB ]; then
  echo "ERROR: Build GDB before running regression tests"
  exit 1
fi

echo ""
echo "Run GDB Regression Test for Ubicom32"
echo ""
date
echo ""

echo "Creating results directory $RESULTS"
rm -rf $RESULTS
mkdir -p $RESULTS

cd $GDB
make -j1 check-gdb RUNTESTFLAGS="-v -v -target_board=ubi32-elf-gdb $TEST" 2>&1 | \
   tee $RESULTS/runtest.log

cp gdb/testsuite/gdb.sum $RESULTS
cp gdb/testsuite/gdb.log $RESULTS
