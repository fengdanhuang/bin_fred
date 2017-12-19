#!/bin/bash

if [ $# -eq 0 ]; then
  echo "usage: Script_Name JarName"
  exit 1
fi

echo -e "\n***************************************************************************************\n"
echo "  The program is:      "$0
echo "  The input Jar Name is:   "$1
echo -e "\n"

myJarFile=$1".jar"
echo "  The jar file which will be generated :           $myJarFile"
echo

homeDir="/usr/users/chaofeng"
subDir="/workspace"

for ((i=1; i<=4; i++))
do
	if [ $i -eq 1 ]; then
		Dir=$homeDir$subDir"/EtomicaApps/bin/"
		newDir=$homeDir$subDir"/EtomicaCore/bin/"
	elif [ $i -eq 2 ]; then
		Dir=$homeDir$subDir"/EtomicaCore/bin/"
		newDir=$homeDir$subDir"/EtomicaGraph/bin/"
	elif [ $i -eq 3 ]; then
		Dir=$homeDir$subDir"/EtomicaGraph/bin/"
		newDir=$homeDir$subDir"/EtomicaChaoFeng/bin/"
	elif [ $i -eq 4 ]; then
		Dir=$homeDir"/workspace/EtomicaChaoFeng/bin/"
		newDir=$homeDir
	fi
	cd $Dir
	zip -q -r $myJarFile etomica
	echo "	zip in $Dir is finished!"
	mv $myJarFile $newDir
done
echo -e "\n***************************************************************************************\n"
