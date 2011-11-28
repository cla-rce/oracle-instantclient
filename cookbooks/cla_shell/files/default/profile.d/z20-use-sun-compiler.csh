#!/bin/csh
# (hint for vim)

if ( ! $?MANPATH ) setenv MANPATH
if ( ! $?PATH ) setenv PATH

# x86_64 fortran compiler
if ( -d /opt/SUNWspro/bin ) then
  alias use-sun-compiler 'setenv PATH /opt/SUNWspro/bin:${PATH}; setenv MANPATH /opt/SUNWspro/man:${MANPATH} '
else
  alias use-sun-compiler 'echo Sun compilers are not installed on this system.'
endif


