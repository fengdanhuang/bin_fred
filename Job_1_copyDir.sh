
if [ $# -eq 0 ]; then
	echo "Usage: Command sourceDir #_of_copies"
	exit
fi

sourceDir=$1
NOfCopies=$2

for ((i=1; i<=$NOfCopies; i++))
do
	echo $sourceDir"_"$i
	newDir=$sourceDir"_"$i
	cp -a $sourceDir $newDir
done	
 
