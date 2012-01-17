#!/bin/csh

if ( -d /opt/maven/current/bin ) then
 set _m2_home=/opt/maven/current
 setenv M2_HOME $_m2_home
 unset _m2_home
 set _m2=${M2_HOME}/bin
 setenv M2 $_m2
 unset _m2
 setenv PATH "${M2}:${PATH}"
endif

