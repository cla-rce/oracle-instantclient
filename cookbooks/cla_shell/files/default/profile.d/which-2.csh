# /etc/csh.cshrc SSRF 2001-09-28 -jjb
#
# Initialization script for tcsh and csh
#
# *********************************************************************
# CHANGELOG:
#  * 1.0:
#    Initial version --jjb
# *********************************************************************

# We don't want to try to pass this to the built-in which on Solaris

set _system=`uname`

if ( "Linux" =~ $_system ) then
  if ( -f /etc/redhat-release ) then
    alias which 'alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
  endif
endif

unset _system

