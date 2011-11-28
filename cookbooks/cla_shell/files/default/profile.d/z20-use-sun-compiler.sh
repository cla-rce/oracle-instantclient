#!/bin/sh
# (hint for vim)

if [ -d /opt/SUNWspro/bin ]; then
  alias use-sun-compiler='PATH=/opt/SUNWspro/bin:${PATH}; export PATH ; MANPATH=/opt/SUNWspro/man:${MANPATH} ; export MANPATH '
else
  alias use-sun-compiler='echo Sun compilers are not installed on this system.'
fi

