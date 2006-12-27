#!/bin/bash

# Remove for develpers (if use links)
[ -L  /usr/bin/sdg_new ] && rm /usr/bin/sdg_new
[ -L  /usr/bin/sdg_build ] && rm /usr/bin/sdg_build
[ -L  /usr/share/doc/sdg ] && rm /usr/share/doc/sdg/
rmdir /usr/share/sdg
