if [ $# -eq 0 ]; then
	echo "Usage: CommandName sourceDir startNo endNo scriptName"
	exit 1
fi

sourceDir=$1
startNo=$2
endNo=$3
scriptName=$4

NOfSubs=$((endNo-startNo+1))
echo "$NOfSubs scripts are submitted to SLURM systems."

for ((i=startNo; i<=endNo; i++))
do
	echo $sourceDir"_"$i
	newDir=$sourceDir"_"$i
	cd $newDir
	sbatch $scriptName
	cd ..
done
