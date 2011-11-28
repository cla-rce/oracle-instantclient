# /etc/profile.d/less.csh SSRF 2001-09-28 -jjb
#
# configure less and handle languages.  From Redhat's config.
#
# *********************************************************************
# CHANGELOG:
#  * 1.0:
#    Initial version --jjb
# *********************************************************************

if ( -x /usr/bin/lesspipe.sh ) then
  setenv LESSOPEN "|/usr/bin/lesspipe.sh %s"
endif

if ( $?LANG ) then
  if ( `echo $LANG | cut -b 1-2` == "ja" ) then
    setenv JLESSCHARSET japanese
  endif
endif

