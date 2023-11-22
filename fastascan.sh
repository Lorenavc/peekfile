#!/bin/bash

echo Fastascan Report

#Establishing current folder as default if user does not provide first argument
if [[ -z $1 ]]
then X=.
else X=$1
fi

#Setting N=0 as default if user does not provide second argument
if [[ -z $2 ]]
then N=0
else N=$2
fi


#Finding the number of fasta/fa files
NUMFILES=$(find "$X" -type f -name "*.fa" -o -name "*.fasta" | wc -l)

##Checking if there are no fasta files
if [[ $NUMFILES -eq 0 ]]; then
echo No fasta/fa files found. Exiting. 
exit 1
fi

echo Number of fasta/fa files: $NUMFILES


#Finding the total number of unique fasta IDs
NUMOFIDS=$(awk '/>/{print $1}' $(find "$X" -type f -name "*.fa" -o -name "*.fasta") | sort | uniq | wc -l) 
echo Total number of unique fasta IDs: $NUMOFIDS
echo 

#Checking if N is a positive integer
if [[ "$N" -lt 0 || "$N" == *.* ]]
then echo The second argument must be a positive integer. Try again with a positive integer to receive full report.
exit 2
fi

echo ====Filename Filetype NumberofSeqs TotalSeqLength SeqType
echo  

#Iterating through fasta/fa files
find "$X" -type f -name "*.fa" -o -name "*.fasta" | while read i; do

##Checking if file is empty
if [[ ! -s $i ]]
then 
  echo ====$i 
  echo File is empty. Skipping file...
  echo
continue
fi

##Check if file is a symbolic link
if [[ -h $i ]]
then FILETYPE="symlink"
else
     FILETYPE="non-symlink"
fi



##Count the number of fasta sequences in file
NUMSEQ=$(grep -c ">" "$i")
if [[ $NUMSEQ -eq 0 ]]
then echo ====$i
echo No sequence IDs were found in file. Skipping file...
echo  
continue
fi

##Calculate total sequence length(excluding spaces, gaps "-", and newline)
TOTAL_SEQ_LENGTH=$(awk '!/>/{gsub(/[- \t\r\n\v\f]/, "", $0); total += length($0)} END {print total}' $i)

##Check if file contains Amino Acid or Nucleotide sequences
if grep -v ">" "$i" | grep -q '[RNDEQHILKMFPSWYV]'
then
TYPESEQ="AminoAcids"
else 
TYPESEQ="Nucleotides"
fi

echo ====$i $FILETYPE $NUMSEQ $TOTAL_SEQ_LENGTH $TYPESEQ


##Printing file lines according to N value
NUMLINES=$(wc -l < "$i") 
if [[ $N -eq 0 ]]
then 
  echo  
elif [[ $NUMLINES -le $((2*$N)) ]] 
then 
  cat "$i"
  echo
else
  head -n "$N" "$i"
  echo ...
  tail -n "$N" "$i" 
  echo
fi

done 

