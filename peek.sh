if [[ -z $2 ]];
then lines=3 
else lines=$2
fi
filelines=$( cat $1 | wc -l)
if [[ $filelines -lt $lines ]];
then cat $1
else
echo warning
head -n $lines $1
echo "..."
tail -n $lines $1
fi
