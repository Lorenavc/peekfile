echo Fastascan Report

#Establishing current folder as default if user does not provide first argument
if [[ -z $1 ]]
then X=.
else X=$1
fi

#Finding the number of fasta/fa files
NUMFILES=$(find $X -type f -name "*.fa" -o -name "*.fasta" | wc -l)
echo Number of fasta/fa files: $NUMFILES
