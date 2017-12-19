if [ $# -eq 0 ]; then
	echo "Usage: CommandName ResultRootName start_No end_No"
	exit 1
fi

ResultRootName=$1
startNo=$2
endNo=$3

NOfChecks=$((endNo-startNo+1))
echo "$NOfChecks result files are checked."

for ((i=startNo; i<=endNo; i++))
do
	echo $ResultRootName"_"$i".out"
	ResultName=$ResultRootName"_"$i".out"
	cat $ResultName
	echo "****************************************************************************************************************"
done	
