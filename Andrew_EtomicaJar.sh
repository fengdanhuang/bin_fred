#!/bin/sh

if [ $# -eq 0 ]; then
   echo "must supply a name for the jar.  it will get dumped in ~/"
   exit 1
fi

set -e
cd /usr/users/chaofeng/workspace/EtomicaApps/bin
zip -q -r /tmp/${1}.jar etomica
cd /usr/users/chaofeng/workspace/EtomicaCore/bin
zip -q -r /tmp/${1}.jar etomica
cd /usr/users/chaofeng/workspace/EtomicaGraph/bin
zip -q -r /tmp/${1}.jar etomica

mv /tmp/${1}.jar ~/
