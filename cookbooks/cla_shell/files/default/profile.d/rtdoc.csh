#!/bin/csh
# 
# add an alias for perldoc to get the RT documentation on the command line
# jjb 2006-03-08

if ( -d /opt/rt3/lib ) then
  alias rtdoc 'env PERL5LIB=/opt/rt3/lib perldoc'
endif

