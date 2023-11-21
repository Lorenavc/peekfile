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

#Iterating through fasta/fa files
find $X -type f -name "*.fa" -o -name "*.fasta" | while read i 
do 

##Check if file is a symbolic link
if [[ -h $i ]]
then FILETYPE="symlink"
else
     FILETYPE="non-symlink"
fi

##Count the number of fasta sequences in file
NUMSEQ=$(grep -c ">" $i)
##Calculate total sequence length(excluding spaces, gaps "-", and newline)
TOTAL_SEQ_LENGTH=$(awk '!/>/{gsub(/[- \t\r\n\v\f]/, "", $0); total += length($0)} END {print total}' $i)

##Check if file contains Amino Acid or Nucleotide sequences
if grep -v ">" $i | grep -q '[RNDEQHILKMFPSWYV]'
then
TYPESEQ="Amino Acids"
else 
TYPESEQ="Nucleotides"
fi

echo ====$i $FILETYPE $NUMSEQ $TOTAL_SEQ_LENGTH $TYPESEQ
done


