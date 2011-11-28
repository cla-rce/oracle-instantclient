#!/bin/sh

if [ -d /opt/maven/current/bin ]; then
 M2_HOME=/opt/maven/current
 M2=${M2_HOME}/bin
 export M2 M2_HOME
 PATH=${M2}:${PATH}
 export PATH
fi
