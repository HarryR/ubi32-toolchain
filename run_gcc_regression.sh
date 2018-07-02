#!/bin/bash


echo ""
echo "Run GCC Regression Test for Ubi32"
echo ""
date
echo ""

# Source common variables and functions
#. ./common.sh

# Source config for the build
#. ./config.build

CONFIG=${1:-ubi32v61}
shift

OPT=${1:-execute.exp}

TOP=$(pwd)

case "$CONFIG" in
  ubi32v5 | ubi32v5be)
    QEMU=qemu-system-ubicom32
    ARCH=ubi32v5
    ENDIAN=mbig-endian
    MAPFILE=ip8k.mapfile
    ;;
  ubi32v5le)
    QEMU=qemu-system-ubicom32el
    ARCH=ubi32v5
    ENDIAN=mlittle-endian
    MAPFILE=ip8k.mapfile
    ;;
  ubi32v6 | ubi32v6le)
    QEMU=qemu-system-ubicom32el
    ARCH=ubi32v6
    ENDIAN=mlittle-endian
    MAPFILE=akronite.mapfile
    ;;
  ubi32v6be)
    QEMU=qemu-system-ubicom32
    ARCH=ubi32v6
    ENDIAN=mbig-endian
    MAPFILE=akronite.mapfile
    ;;
  ubi32v61 | ubi32v61le)
    QEMU=qemu-system-ubicom32el
    ARCH=ubi32v61
    ENDIAN=mlittle-endian
    MAPFILE=akronite.mapfile
    ;;
  ubi32v61be)
    QEMU=qemu-system-ubicom32
    ARCH=ubi32v61
    ENDIAN=mbig-endian
    MAPFILE=akronite.mapfile
    ;;
  *) 
    echo "Invalid architecture: $CONFIG"
    exit 1
    ;;
esac

TODAY=`date "+%Y_%m_%d"`
RESULTS=$TOP/results/$TODAY-$ARCH-$ENDIAN
GCC=$TOP/install/bin/ubi32-elf-gcc
DEJADIR=/zfs/qualcomm/dev/ubicom32-toolchain/src/dejagnu
TARGET_BOARD=ubicom32-qemu
LDSCRIPT=$TOP/install/ubi32-none-elf/lib/ubi32-qemu.ld
MAPFILE=$TOP/src/qemu/target-ubicom32/$MAPFILE
RUNTEST=$DEJADIR/runtest
QEMU=$TOP/install/bin/$QEMU
TESTDIR=$TOP/test
SRCDIR=$TOP/src

echo "Removing test directory $TESTDIR"
rm -rf $TESTDIR
mkdir -p $TESTDIR

echo "Creating results directory $RESULTS"
rm -rf $RESULTS
mkdir -p $RESULTS

pushd $TESTDIR

# Set up test parameters
cat > target_config.exp <<EOF
set target_config_cflags  "-march=$ARCH -$ENDIAN -msemihosting -fstack-protector"
set target_config_cflags  "-march=$ARCH -$ENDIAN -msemihosting -fframe-downward"
set target_config_cflags  "-march=$ARCH -$ENDIAN -msemihosting"
set target_config_ldflags "-T$LDSCRIPT"
set target_config_sim     "$QEMU"
set target_config_sim_flags "-semihosting -readconfig $MAPFILE -kernel"
set tool_timeout 60
EOF

cat > site.exp<<EOF
set rootme ""
set srcdir "$ROOTDIR"
set host_triplet x86_64-unknown-linux-gnu
set build_triplet x86_64-unknown-linux-gnu
set target_triplet ubicom32-unknown-elf
set target_alias ubicom32-elf
set libiconv ""
set CFLAGS ""
set CXXFLAGS ""
set TESTING_IN_BUILD_TREE 1
set HAVE_LIBSTDCXX_V3 1
set tmpdir "$TESTDIR"
set srcdir "$SRCDIR/gcc/gcc/testsuite"
if ![info exists boards_dir] {
    set boards_dir "$DEJADIR/baseboards"
}
lappend boards_dir "$DEJADIR/baseboards"
EOF

touch $RESULTS/gcc.start
echo "which $QEMU"
which $QEMU


$RUNTEST --tool gcc --tool_exec $GCC --target_board=$TARGET_BOARD  \
	$OPT 2>&1 | tee runtest.log

touch $RESULTS/gcc.stop

cp gcc.sum $RESULTS
cp gcc.log $RESULTS

popd
