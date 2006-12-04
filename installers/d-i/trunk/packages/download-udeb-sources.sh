#!/bin/bash

for x in $(cat ../doc/source-packages-di.list)
do
	apt-get source $x; 
done
