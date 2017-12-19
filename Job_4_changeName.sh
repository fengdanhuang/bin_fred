if [ $# -eq 0 ]; then
	echo "Usage: CommandName sourceDir startNo endNo resultName"
	exit 1
fi

sourceDir=$1
startNo=$2
endNo=$3
resultName=$4

NOfChanges=$((endNo-startNo+1))
echo "$NOfChanges files are moved out from directories."

for ((i=startNo; i<=endNo; i++))
do
	echo $sourceDir"_"$i
	newDir=$sourceDir"_"$i
	cd $newDir

	ls -l | grep $resultName > /dev/null
	if [ $? -ne 0 ]; then
		echo "This job has not started yet!"
		exit
	fi

	newResultName=${resultName%.*}"_"$i".out" #delete right side characters of ".", leave left side of ".".
	echo $newResultName
	mv $resultName $newResultName
	mv $newResultName ..
	cd ..
	echo "****************************************************************************************************************"
done	 
