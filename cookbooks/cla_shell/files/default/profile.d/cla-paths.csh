# if the variable isn't already set when this runs, .cshrc will stop
# processing completely.
if ( ! $?PATH ) setenv PATH
if ( ! $?MANPATH ) setenv MANPATH

if ( -d /usr/dt/bin ) setenv PATH ${PATH}:/usr/dt/bin
if ( -d /usr/dt/man ) setenv MANPATH ${MANPATH}:/usr/dt/man

if ( -d /usr/openwin/bin ) setenv PATH ${PATH}:/usr/openwin/bin
if ( -d /usr/openwin/man ) setenv MANPATH ${MANPATH}:/usr/openwin/man

if ( -d /usr/ccs/bin ) setenv PATH ${PATH}:/usr/ccs/bin
if ( -d /usr/ccs/man ) setenv MANPATH ${MANPATH}:/usr/ccs/man

if ( -d /opt/csw/bin ) setenv PATH ${PATH}:/opt/csw/bin
if ( -d /opt/csw/man ) setenv MANPATH ${MANPATH}:/opt/csw/man

if ( -d /opt/csw/apache2/bin ) setenv PATH ${PATH}:/opt/csw/apache2/bin
if ( -d /opt/csw/apache2/man ) setenv MANPATH ${MANPATH}:/opt/csw/apache2/man

if ( -d /opt/csw/mysql5/bin ) setenv PATH ${PATH}:/opt/csw/mysql5/bin
if ( -d /opt/csw/mysql5/man ) setenv MANPATH ${MANPATH}:/opt/csw/mysql5/man

if ( -d /opt/csw/mysql4/bin ) setenv PATH ${PATH}:/opt/csw/mysql4/bin
if ( -d /opt/csw/mysql4/man ) setenv MANPATH ${MANPATH}:/opt/csw/mysql4/man
