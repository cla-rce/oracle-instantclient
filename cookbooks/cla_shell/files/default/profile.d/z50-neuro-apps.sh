# /etc/profile.d/z10-neuro-apps.sh DRCS 2006-11-16 -jjb
#
# hack for the neuro apps from Kemal
#
# *********************************************************************
# CHANGELOG:
#  * 1.0:
#    Initial version --jjb
# *********************************************************************

if [ -r /opt/neuro.bash.shell ]; then
  . /opt/neuro.bash.shell
elif [ -r /opt/bliss/neuro.sh ]; then
  . /opt/bliss/neuro.sh 
fi

# freesurfer .fiswidgets

if [ ! -f ${HOME}/.fisproperties -a -r /opt/fiswidgets/fisproperties.default ];  then
  cp /opt/fiswidgets/fisproperties.default $HOME/.fisproperties
fi

# freesurfer shell code

if [ -n "$FREESURFER_HOME" ]; then 
  # suppress the output from the script
  FS_FREESURFERENV_NO_OUTPUT=1

  export FS_FREESURVERENV_NO_OUTPUT
  
  if [ -r ${FREESURFER_HOME}/SetUpFreeSurfer.sh ]; then
    . ${FREESURFER_HOME}/SetUpFreeSurfer.sh
  fi
fi

