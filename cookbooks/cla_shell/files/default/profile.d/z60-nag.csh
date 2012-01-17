#!/bin/tcsh

# flexlm-based products that don't need a license server
if ( -f /etc/nag/license.dat ) then
  setenv LM_LICENSE_FILE /etc/nag/license.dat
endif

# newer NAG products use Kusari, which has a different license file
if ( -f /etc/nag/kusari_license.dat ) then
  setenv NAG_KUSARI_FILE /etc/nag/kusari_license.dat
else if ( -f /opt/nag/nag.license ) then
  setenv NAG_KUSARI_FILE /opt/nag/nag.license
endif

# needs LD_LIBRARY_PATH, which is fundamentally broken by design
if ( -d /opt/nag/F95/lib ) then
  if ( ! $?LD_LIBRARY_PATH ) then 
    setenv LD_LIBRARY_PATH
  endif
  setenv LD_LIBRARY_PATH "/opt/nag/F95/lib:${LD_LIBRARY_PATH}"
endif

if ( -d /opt/nag/F95/bin ) then
  setenv PATH /opt/nag/F95/bin:${PATH}
endif

# finally, add it to the path if it's installed in /opt/nag
#if ( -d /opt/nag/bin ) then
#  setenv NAG_HOME /opt/nag
#  setenv PATH ${NAG_HOME}/bin:${PATH}
#  if ( ! $?MANPATH ) then 
#    # if we attempt to reference MANPATH when it is not set, it will produce
#    # an error to the user.
#    setenv MANPATH
#  endif
#  setenv MANPATH ${NAG_HOME}/man:${MANPATH}
#endif



