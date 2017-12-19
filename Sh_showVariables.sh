#!/bin/sh

echo
echo "**********Linux Variables**********"

echo "\$#(Number of Arguments)  ="$#
echo "\$0(Name of Scripts)      ="$0
echo "\$1(First Argument)       ="$1
echo "\$2(Second Argument)      ="$2
echo "\$@(Arguments List)       ="$@
echo "\$*(Arguments List,>9)    ="$*
echo "\$\$(Current Pocess Id)    ="$$
echo "\$?(Return State)         ="$?

echo
