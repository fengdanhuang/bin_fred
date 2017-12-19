if [ $# -eq 0 ]; then
	echo "Usage: CommandName sourceDir start_No end_No resultName"
	exit 1
fi

sourceDir=$1
startNo=$2
endNo=$3
resultName=$4

NOfChecks=$((endNo-startNo+1))
echo "$NOfChecks directories are checked."

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

	linesInResult=`cat $resultName | wc -l`
	if [ $linesInResult -eq 6 ]; then
		cat $resultName
		echo "$newDir is not finished"
		exit
	fi	
	cat $resultName
	echo "****************************************************************************************************************"
	cd ..
done	
