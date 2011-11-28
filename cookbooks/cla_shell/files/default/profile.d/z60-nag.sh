#!/bin/bash

if [ -f /etc/nag/license.dat ]; then
  LM_LICENSE_FILE=/etc/nag/license.dat
  export LM_LICENSE_FILE
fi

# newer NAG products use Kusari, which has a different license file
if [ -f /etc/nag/kusari_license.dat ]; then
  NAG_KUSARI_FILE=/etc/nag/kusari_license.dat
  export NAG_KUSARI_FILE
elif [ -f /opt/nag/nag.license ]; then
  NAG_KUSARI_FILE=/opt/nag/nag.license
  export NAG_KUSARI_FILE
fi

# needs LD_LIBRARY_PATH, which is fundamentally broken by design
if [ -d /opt/nag/F95/lib ]; then
  if [ -n "$LD_LIBRARY_PATH" ]; then 
    LD_LIBRARY_PATH="/opt/nag/F95/lib:${LD_LIBRARY_PATH}"
  else
    LD_LIBRARY_PATH="/opt/nag/F95/lib"
  fi
  export LD_LIBRARY_PATH
fi

if [ -d /opt/nag/F95/bin ]; then
  PATH=/opt/nag/F95/bin:${PATH}
  export PATH
fi
