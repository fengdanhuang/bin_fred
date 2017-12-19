if [ $# -eq 0 ]; then
	echo "Usage: CommandName sourceDir startNo endNo"
	exit 1
fi

sourceDir=$1
startNo=$2
endNo=$3
NOfDelete=$((endNo-startNo+1))
echo "$NOfDelete directories are deleted."

for ((i=startNo; i<=endNo; i++))
do
	echo $sourceDir"_"$i
	newDir=$sourceDir"_"$i
	rm -rf $newDir
done	 

