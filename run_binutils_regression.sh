#!/bin/bash

ROOTDIR=`pwd`
TOOLDIR=$ROOTDIR/../ubicom32-toolchain
DATE=$(date +%Y-%m-%d-%H-%M)
SRCDIR=$ROOTDIR/src
BLDDIR=$ROOTDIR/build
GDB=$BLDDIR/binutils
RELDIR=$TOOLDIR/release
QEMUDIR=$ROOTDIR/install
DEJADIR=$TOOLDIR/src/dejagnu
PATH=$RELDIR/bin:$QEMUDIR/bin:$DEJADIR:$PATH
RESULTSDIR=$ROOTDIR/results
RESULTS=$RESULTSDIR/gas/$DATE

export DEJAGNULIBS=$TOOLDIR/src/dejagnu

if [ ! -d $GDB ]; then
  echo "ERROR: Build Binutils before running regression tests"
  exit 1
fi

echo ""
echo "Run GAS Regression Test for Ubi32"
echo ""
date
echo ""

echo "Creating results directory $RESULTS"
rm -rf $RESULTS
mkdir -p $RESULTS

cd $GDB
make -j1 check-gas RUNTESTFLAGS="$TEST" 2>&1 | \
   tee $RESULTS/runtest.log

cp gas/testsuite/gas.sum $RESULTS
cp gas/testsuite/gas.log $RESULTS
