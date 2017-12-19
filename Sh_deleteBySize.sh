if [ $# -eq 0 ]; then
	echo "Usage: CommandName size"
	exit 1
fi

size=$1
echo "The files to be deleted have the size $size bytes."
fileNames=`ls -l | awk -v size=$size '{if ($5==size) print $9}'`
echo "The files are:"
echo $fileNames
rm -rvf $fileNames
