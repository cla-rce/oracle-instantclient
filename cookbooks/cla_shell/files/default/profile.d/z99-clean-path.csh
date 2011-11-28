# if the variable isn't already set when this runs, .cshrc will stop
# processing completely.
if ( ! $?PATH ) setenv PATH

set newpath = ()
set inpath = 0
foreach d ($path[*])
  foreach od ($newpath[*])
    if ( "$d" == "$od" ) then
      set inpath = 1
    endif
  end
  if ( "$inpath" != "1" ) then
    if ( -d $d ) set newpath = ($newpath $d)
  endif
  set inpath = 0
end

unset inpath
set path = ( $newpath )
unset newpath

# path is now free of duplicates.

