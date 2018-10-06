#!/bin/bash

TEST=${1:--directory=gdb.base}

TOP=$(pwd)
DATE=$(date +%Y-%m-%d-%H-%M)
SRCDIR=$TOP/src

LDSCRIPT=$TOP/install/ubi32-none-elf/lib/ubi32-qemu.ld
MAPFILE=$TOP/src/qemu/target-ubicom32/akronite.mapfile
RELDIR=$TOP/install
DEJAGNU=$TOP/dejagnu
PATH=$RELDIR/bin:$PATH
TESTDIR=$TOP/test
RESULTS=$TOP/results/gdb/$DATE

echo ""
echo "Run GDB Regression Test for Ubicom32"
echo ""
date
echo ""

echo "Creating results directory $RESULTS"
rm -rf $RESULTS
mkdir -p $RESULTS

echo "Removing test directory $TESTDIR"
rm -rf $TESTDIR
mkdir -p $TESTDIR

pushd $TESTDIR
cp $LDSCRIPT .
cp $MAPFILE .

cat > site.exp<<EOF
set srcdir "$SRCDIR/gdb/gdb/testsuite"
set host_triplet x86_64-unknown-linux-gnu
set build_triplet x86_64-unknown-linux-gnu
set target_triplet ubi32-none-elf
set target_alias ubi32-elf
set tool gdb
source $SRCDIR/gdb/gdb/testsuite/lib/append_gdb_boards_dir.exp
if ![info exists boards_dir] {
    set boards_dir "$DEJAGNU"
}
lappend boards_dir "$DEJAGNU"
EOF

runtest -v -target_board=ubi32-elf-gdb $TEST 2>&1 | tee $RESULTS/runtest.log

cp gdb.sum $RESULTS
cp gdb.log $RESULTS

popd
