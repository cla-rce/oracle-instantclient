# Solaris 10 hackery
if ( -x /usr/xpg4/bin/id ) then
  set _id=/usr/xpg4/bin/id
else if ( -x /usr/bin/id ) then
  set _id=/usr/bin/id
else if ( -x /bin/id ) then
  set _id=/bin/id
else if ( -x /usr/local/bin/id ) then
  set _id=/usr/local/bin/id
else
  # fail semi-gracefully for the unexpected situation
  set _id=/bin/true
endif

set _whoami=`$_id -u -n`
   
if ( "$_whoami" == "root" ) then
  umask 022
else
  umask 002
endif

