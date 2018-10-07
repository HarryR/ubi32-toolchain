#!/bin/bash

TOP=`pwd`

UPDATE=$1

# Update top level directory
  if [ "$UPDATE" = "update" ]; then
    git pull > /dev/null
  fi

mkdir -p src

#  List of repos to check out
#  target-dir;repo URL;branch
repolist[0]="binutils;https://source.codeaurora.org/external/ubicom/ubi32-binutils-gdb;ubi32-binutils"
repolist[1]="gcc;https://source.codeaurora.org/external/ubicom/ubi32-gcc;ubi32"
repolist[2]="newlib;https://source.codeaurora.org/external/ubicom/ubi32-newlib;ubi32"
repolist[3]="binutils;https://source.codeaurora.org/external/ubicom/ubi32-binutils-gdb;ubi32-binutils"
repolist[4]="gdb;https://source.codeaurora.org/external/ubicom/ubi32-binutils-gdb;ubi32-gdb"
repolist[5]="qemu;https://source.codeaurora.org/external/ubicom/ubi32-qemu;ubi32"
repolist[6]="DONE"

let i=0
while [ ! "${repolist[i]}" = "DONE" ]; do
  IFS=';' read -ra elem <<< "${repolist[i]}"
  dir="${elem[0]}"
  URL="${elem[1]}"
  branch="${elem[2]}"
  if [[ -d src/$dir && -z "$(ls -A src/$dir)" ]]; then
    rm -rf src/$dir
  fi
  if [ ! -d src/$dir ]; then 
    git clone --branch $branch --single-branch $URL src/$dir
  else
    pushd src/$dir > /dev/null
    git checkout $branch 2> /dev/null
    if [ "$UPDATE" = "update" ]; then
      git pull > /dev/null
    fi
    popd > /dev/null
  fi
  i=$((i + 1))
done
