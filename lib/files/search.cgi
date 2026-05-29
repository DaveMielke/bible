#!/bin/sh
set -e

TCLLIBPATH=/mnt/opt/dave/lib/tcl
export TCLLIBPATH

LANG=C.UTF-8
export LANG

cd -P "`dirname "${0}"`"
cd ..
. ./vars
export BIBLE_VERSION

exec "${BIBLE_ROOT}/bin/bible-exsearch"
exit 0
