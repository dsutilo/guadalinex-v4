#!/bin/bash

# Install for developers (using links)
DIR=$(pwd)
mkdir /usr/share/sdg/
ln -s $DIR/sdg-skel /usr/share/sdg/
ln -s $DIR/sdg_new  /usr/bin
ln -s $DIR/sdg_build  /usr/bin
ln -s $DIR/doc /usr/share/doc/sdg

