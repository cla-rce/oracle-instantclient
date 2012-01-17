#!/bin/sh

if [ -d /var/lib/gems/1.9/bin ]; then 
  PATH=${PATH}:/var/lib/gems/1.9/bin
fi

if [ -d /var/lib/gems/1.8/bin ]; then 
  PATH=${PATH}:/var/lib/gems/1.8/bin
fi

export PATH
