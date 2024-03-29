#!/bin/bash

TOP=`pwd`
BLD=$TOP/build
SCRIPTS=$TOP/scripts

echo " "
echo "Building UBI32 tool chain"
echo " "

function usage {
  echo ""
  echo "./build_ubi32.sh [<options>]..."
  echo "Build Ubi32 Tool Chain"
  echo ""
  echo "  Options:"
  echo "    binutils-- (Re)build Binutils"
  echo "    check   -- Check source status"
  echo "    clean   -- Delete current build, install, log directories"
  echo "    debug   -- Build debug versions of tool chain"
  echo "    gcc     -- (Re)build Final GCC"
  echo "    gcc_all -- (Re)build Stage1, Newlib, and Final GCC"
  echo "    gdb     -- (Re)build GDB"
  echo "    newlib  -- (Re)build Newlib and GCC"
  echo "    qemu    -- (Re)build QEMU"
  echo "    update  -- Update tool chain"
  echo "    help    -- Print this help message"
  echo ""
}

function check_rc
{
  if [ $1 != 0 ]; then
    echo ""
    echo "ERROR: Build failed"
    echo ""
    exit $rc
  fi
}

for opt in "$@"; do
  case "$opt" in
    'binutils')	rm -f $BLD/binutils/.build_complete
		;;
    'clean')	CLEAN=yes
		;;
    'check')	CHECK=yes
		;;
    'debug')	OPTIONS=debug
		;;
    'help')	HELP=yes
		;;
    'gcc_all')	rm -f $BLD/gcc_stage1/.build_complete
		rm -f $BLD/newlib/.build_complete
		rm -f $BLD/gcc/.build_complete
		;;
    'gcc')	rm -f $BLD/gcc/.build_complete
		;;
    'gdb')	rm -f $BLD/gdb/.build_complete
		;;
    'newlib')   rm -f $BLD/newlib/.build_complete
    		rm -f $BLD/gcc/.build_complete
		;;
    'qemu')	rm -f $BLD/qemu/.build_complete
		;;
    'update')	UPDATE=update
    		CHECK=yes
		;;
    *)		HELP=yes
		echo "Error: option $opt not recognized"
		;;
  esac
done

if [ "$HELP" == "yes" ]; then
  usage
  exit 0
fi

if [ "$CLEAN" == "yes" ]; then
 read -p "Delete build, install, and log directories (y/n)? " REPLY
 if [ "$REPLY" == 'y' ]; then
   echo "Removing build, install, and log directories"
   rm -rf build install log
   echo ""
 fi
fi

if [ "$CHECK" == "yes" ]; then
  echo "Verifying source directories"
  $SCRIPTS/checkout.sh $UPDATE
fi

if [ -f $BLD/binutils/.build_complete ]; then
  echo "  Binutils already built"
else
  $SCRIPTS/build_binutils.sh $OPTIONS
  check_rc $?
fi

if [ -f $BLD/gcc/.build_complete ]; then
  echo "  GCC already built"
else
  if [ -f $BLD/gcc_stage1/.build_complete ]; then
    echo "  GCC stage 1 already built"
  else
    rm -f $BLD/gcc/.build_complete 
    $SCRIPTS/build_gcc_stage1.sh $OPTIONS
    check_rc $?
  fi

  if [ -f $BLD/newlib/.build_complete ]; then
    echo "  Newlib already built"
  else
    $SCRIPTS/build_newlib.sh $OPTIONS
    check_rc $?
  fi

  if [ -f $BLD/gcc/.build_complete ]; then
    echo "  GCC already built"
  else
    $SCRIPTS/build_gcc_final.sh $OPTIONS
    check_rc $?
  fi
fi

if [ -f $BLD/gdb/.build_complete ]; then
  echo "  GDB already built"
else
  $SCRIPTS/build_gdb.sh $OPTIONS
  check_rc $?
fi

if [ -f $BLD/qemu/.build_complete ]; then
  echo "  QEMU already built"
else
  $SCRIPTS/build_qemu.sh $OPTIONS
  check_rc $?
fi

echo " "
echo "UBI32 Tool Chain Build Done"
date
echo " "
