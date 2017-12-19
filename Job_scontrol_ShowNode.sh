if [ $# -eq 0 ]; then
	echo "Usage: CommandName show node NodeName"
	exit 1
fi

NodeName=$1
scontrol show node $NodeName
