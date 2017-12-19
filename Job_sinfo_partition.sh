if [ $# -eq 0 ]; then
	echo "Usage: CommandName PartitionName"
	exit 1
fi

PartitionName=$1
sinfo -p $PartitionName
