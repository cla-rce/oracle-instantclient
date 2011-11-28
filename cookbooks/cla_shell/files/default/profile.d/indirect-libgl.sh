#!/bin/sh

## Set up environment to allow software rendering of GLX

if [ -f /etc/lsb-release ]; then
  grep 'DISTRIB_ID=Ubuntu' /etc/lsb-release >/dev/null
  if [ $? -eq 0 ]; then 
    LIBGL_ALWAYS_INDIRECT=y
    export LIBGL_ALWAYS_INDIRECT
  fi
fi
