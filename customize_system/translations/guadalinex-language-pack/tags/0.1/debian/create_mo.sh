#!/bin/bash

CURDIR=$1

PO_FILES=$(ls $CURDIR/po/*.po)

for f in $PO_FILES;
do
    MO_FILE=$(echo $f | sed -e "s:po$:mo:g")
    /usr/bin/msgfmt $f -o $MO_FILE
done