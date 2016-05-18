#!/bin/bash


echo ""
echo "Run GDB Regression Test for Ubicom32"
echo ""
date
echo ""

TEST=${1:--directory=gdb.base}

ROOTDIR=`pwd`
TOOLDIR=/zfs/qualcomm/qualcomm-toolchain
DATE=$(date +%Y-%m-%d)
SRCDIR=$ROOTDIR/src
BLDDIR=$ROOTDIR/build
GDB=$BLDDIR/gdb
RELDIR=$TOOLDIR/release
QEMUDIR=$TOOLDIR/release/qemu/bin
PATH=$RELDIR/bin:$QEMUDIR/bin:$PATH
RESULTSDIR=$ROOTDIR/results
RESULTS=$RESULTSDIR/gdb/$DATE

export DEJAGNULIBS=$TOOLDIR/src/dejagnu

echo "Creating results directory $RESULTS"
rm -rf $RESULTS
mkdir -p $RESULTS

cd $GDB
make -j1 check-gdb RUNTESTFLAGS="-v -v -target_board=ubi32-elf-gdb $TEST" 2>&1 | \
   tee $RESULTS/runtest.log

cp gdb/testsuite/gdb.sum $RESULTS
cp gdb/testsuite/gdb.log $RESULTS
