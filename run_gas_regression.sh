#!/bin/bash

TOP=`pwd`
DATE=$(date +%Y-%m-%d-%H-%M)
SRCDIR=$TOP/src
RELDIR=$TOP/install
DEJAGNU=$TOP/dejagnu
PATH=$RELDIR/bin:$PATH
RESULTS=$TOP/results/gas/$DATE
TESTDIR=$TOP/test

echo ""
echo "Run GAS Regression Test for Ubi32"
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

cat > site.exp<<EOF
set srcdir "$SRCDIR/binutils/gas/testsuite"
set host_triplet x86_64-unknown-linux-gnu
set build_triplet x86_64-unknown-linux-gnu
set target_triplet ubi32-unknown-elf
set target_alias ubi32-elf
if ![info exists boards_dir] {
    set boards_dir "$DEJAGNU"
}
lappend boards_dir "$DEJAGNU"
EOF

runtest --tool gas 

cp gas.sum $RESULTS
cp gas.log $RESULTS
