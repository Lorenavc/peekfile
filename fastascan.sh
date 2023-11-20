echo Fastascan Report

#Establishing current folder as default if user does not provide first argument
if [[ -z $1 ]]
then X=.
else X=$1
fi

#Finding the number of fasta/fa files
NUMFILES=$(find $X -type f -name "*.fa" -o -name "*.fasta" | wc -l)

##Checking if there are no fasta files
if [[ $NUMFILES -eq 0 ]]; then
echo No fasta/fa files found. Exiting 
exit 1
fi

echo Number of fasta/fa files: $NUMFILES


#Finding the total number of unique fasta IDs
FILES=$(find $X -type f -name "*.fa" -o -name "*.fasta")
NUMOFIDS=$(awk '/>/{print $1}' $FILES | sort | uniq | wc -l) 
echo Total number of unique fasta IDs: $NUMOFIDS
