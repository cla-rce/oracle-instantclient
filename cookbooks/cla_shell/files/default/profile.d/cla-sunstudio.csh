# if the variable isn't already set when this runs, .cshrc will stop
# processing completely.
if ( ! $?PATH ) setenv PATH
if ( ! $?MANPATH ) setenv MANPATH

if ( -x /opt/SUNWspro/bin/cc ) then
  set _studio=/opt/SUNWspro
else if ( -x /opt/studio/12/SUNWspro/bin/cc ) then
  set _studio=/opt/studio/12/SUNWspro
else if ( -x /opt/studio/11/SUNWspro/bin/cc ) then
  set _studio=/opt/studio/11/SUNWspro
else if ( -x /opt/studio/8/SUNWspro/bin/cc ) then
  set _studio=/opt/studio/8/SUNWspro
endif

if ($?_studio) then
  setenv PATH ${PATH}:${_studio}/bin
  setenv MANPATH ${MANPATH}:${_studio}/man
endif

