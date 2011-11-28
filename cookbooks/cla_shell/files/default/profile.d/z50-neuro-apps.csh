# /etc/profile.d/z10-neuro-apps.csh DRCS 2006-11-16 -jjb
#
# hack for the neuro apps from Kemal
#
# *********************************************************************
# CHANGELOG:
#  * 1.0:
#    Initial version --jjb
# *********************************************************************

if ( -r /opt/neuro.tcsh.shell ) then
  source /opt/neuro.tcsh.shell
else if ( -r /opt/bliss/neuro.csh ) then
  source /opt/bliss/neuro.csh 
endif

# freesurfer .fiswidgets

if ( ! -f ${HOME}/.fisproperties ) then
  if ( -r /opt/fiswidgets/fisproperties.default ) then
    cp /opt/fiswidgets/fisproperties.default $HOME/.fisproperties
  endif
endif

# freesurfer shell code

if ( $?FREESURFER_HOME )  then
  # supress the output from the script
  setenv FS_FREESURFERENV_NO_OUTPUT 1
  if ( -r ${FREESURFER_HOME}/SetUpFreeSurfer.csh ) then
    source ${FREESURFER_HOME}/SetUpFreeSurfer.csh
  endif
endif



