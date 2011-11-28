#!/bin/tcsh

## Set up environment to allow software rendering of GLX

if ( -f /etc/lsb-release ) then
  grep 'DISTRIB_ID=Ubuntu' /etc/lsb-release >/dev/null && setenv LIBGL_ALWAYS_INDIRECT y
endif

