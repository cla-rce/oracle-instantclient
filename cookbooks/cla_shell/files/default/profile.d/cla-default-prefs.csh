# basic user preferences -- can be overrriden in ~user (csh)
#
# *********************************************************************
# CHANGELOG:
#  * 1.0:
#    Initial version --jjb
#  * 1.1:
#    Changed umask to 002 -jjb 2004-01-08
#  * 1.1.1:
#    Updated comments on umask -jjb 2004-01-22
#  * 1.1.2:
#    umask is 022 for root. -jjb 2004-01-22
# *********************************************************************

if ($?prompt) then
  # We are interactive.  Don't do anything unless we are. :)
  if ($?tcsh) then
    set prompt="%n@%m:%.5 %\!% "
    set prompt2="shell loop%"
    set prompt3='DO YOU MEAN: "%R" (y,e,n)[n]'
  else
    # blech.  Actual csh
    set prompt=\[$USER@`hostname`\]\$
  endif
  
  # set up a few environment variables.
  if ( -x /usr/bin/pico ) then
    set _editor=/usr/bin/pico
  else if ( -x /opt/csw/bin/pico ) then
    set _editor=/opt/csw/bin/pico
  else if ( -x /usr/local/bin/pico ) then
    set _editor=/usr/local/bin/pico
  else if ( -x /usr/bin/vim ) then
    set _editor=/usr/bin/vim
  else if ( -x /opt/csw/bin/vim ) then
    set _editor=/opt/csw/bin/vim
  else if ( -x /usr/local/bin/vim ) then
    set _editor=/usr/local/bin/vim
  else if ( -x /usr/bin/vi ) then
    set _editor=/usr/bin/vi
  # redhat minimal install
  else if ( -x /bin/vi ) then
    set _editor=/bin/vi 
  endif

  if ( $?_editor ) then
    setenv EDITOR $_editor
    setenv VISUAL $_editor
  else
    echo "Error setting EDITOR and VISUAL environment variables"
    echo "Leaving it unset.  You may have problems."
  endif
  
  unset _editor
  
  if ( -x /usr/bin/less ) then
    set _pager=/usr/bin/less
  else if ( -x /opt/csw/bin/less ) then
    set _pager=/opt/csw/bin/less
  else if ( -x /usr/sfw/bin/less ) then
    set _pager=/usr/sfw/bin/less
  else if ( -x /usr/local/bin/less ) then
    set _pager=/usr/local/bin/less
  else if ( -x /usr/bin/more ) then
    set _pager=/usr/bin/more
  else if ( -x /usr/local/bin/more ) then
    set _pager=/usr/local/bin/more
  else if ( -x /usr/bin/pg ) then
    set _pager=/usr/bin/pg 
  endif
  
  setenv PAGER $_pager
  unset _pager

  # aliases
  if ( -x /usr/bin/vim ) then
    set _vim=/usr/bin/vim
  else if ( -x /opt/csw/bin/vim ) then
    set _vim=/opt/csw/bin/vim
  else if ( -x /usr/local/bin/vim ) then
    set _vim=/usr/local/bin/vim
  endif
  
  if ($?_vim) then
    alias vi $_vim
    unset _vim
  endif

  alias rm 'rm -i'
  alias mv 'mv -i'
  alias cp 'cp -ip' 

  # SysV printing sucks.  But, we try to make it easier.
  alias lp 'lp -o nobanner'

  # this stuff won't work on csh -- but it will be ignored.
  # (don't clobber existing files with redirection)
  set noclobber
  # (don't keep history across logins)
  set savehist=0
  # (don't use autologout)
  unset autologout
  # (Autocomplete command names)
  set autolist=ambiguous

endif # (interactive shell)

# will be caught interactive or not...
# changed 1/2004 -jjb

if ( ! $?HOSTNAME ) then
  setenv HOSTNAME `hostname`
endif

if ( ! $?ALIAS ) then
  setenv ALIAS `echo $HOSTNAME | sed -e 's/\..*//'`
endif


