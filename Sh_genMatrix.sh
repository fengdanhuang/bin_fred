
if [ $# -eq 0 ]; then
	echo "Usage: Program_Name Number_Of_Row Number_Of_Column"
	exit 1
fi

row=$1
column=$1

echo "Generate data with $row rows and $column columns"

awk -v row=$row -v column=$column '
BEGIN{
	for(i=0;i<row;i++){
		for(j=0;j<column;j++)
			printf "%d\t", rand()*10;
		print
	}
}' > input_1.txt
