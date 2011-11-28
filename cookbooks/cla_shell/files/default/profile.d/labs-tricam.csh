#!/bin/csh

set _grep=/bin/true

if ( -x /bin/grep ) then
  set _grep=/bin/grep
else if  ( -x /usr/bin/grep ) then
  set _grep=/usr/bin/grep
else if ( -x /usr/local/bin/grep ) then
  set _grep=/usr/local/bin/grep 
endif 

/usr/bin/id -a | $_grep '\(tricam\)' > /dev/null
set _retval=$?

if ( "$_retval" == 0 ) then 
  if ( -d /labs/tricam/bin ) then 
    setenv PATH ${PATH}:/labs/tricam/bin
  endif 
endif

