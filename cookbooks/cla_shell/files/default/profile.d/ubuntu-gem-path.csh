#!/bin/tcsh

if ( -d /var/lib/gems/1.9/bin ) then 
  setenv PATH ${PATH}:/var/lib/gems/1.9/bin
endif

if ( -d /var/lib/gems/1.8/bin ) then 
  setenv PATH ${PATH}:/var/lib/gems/1.8/bin
endif

