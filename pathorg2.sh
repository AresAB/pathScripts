#!/bin/sh

s_flag=false
expecting_s_input=false
f_flag=false
p_flag=false
i_flag=false

FlagHandler(){
	read -a flag_array <<< $(flaghandler.sh $1)

	for flag in ${flag_array[*]}
	do
		case $flag in
			s | search)
				if [ $f_flag == true ]; then 
					exit 1
				fi
				s_flag=true
				expecting_s_input=true
				;;
			f | filter)
				if [ $s_flag == true ]; then 
					exit 1
				fi
				f_flag=true
				;;
			p | package)
				p_flag=true
				;;
			i | inverse)
				i_flag=true
				;;
		esac
	done
}

while [ $# -gt 0 ]; do
	if [ $expecting_s_input == true ]; then
		input="$1"
		expecting_s_input=false
		continue
	fi
	FlagHandler $1
	shift
done
if [ $expecting_s_input == true ]; then
	exit 1
fi

if [ $f_flag == true ]; then 
	if [ $i_flag == true ]; then
		i_var=1
	else
		i_var=0
	fi

	echo "" > $TMP/pathscanresults.txt
	echo $PATH | sed 's/ /\\ /g' | sed 's/(/\\(/g' | 
	sed 's/)/\\)/g' | sed 's/:/\n/g' | 
	awk '{print "test -a "$0"\nif [ $? == '\"$i_var\"' ]; then echo \""$0"\" >> $TMP/pathscanresults.txt\nfi"}' > $TMP/pathscan.txt
	
	sh $TMP/pathscan.txt
	if [ $p_flag == true ]; then
		result=$( awk '{print $0}' $TMP/pathscanresults.txt )
		echo $result | sed 's/\\ /\\--/g' | sed 's/ /:/g' |
		sed 's/\\--/ /g'
	else
		cat $TMP/pathscanresults.txt
	fi
	exit 0
elif [ $s_flag == true ]; then 
	if [ $i_flag == true ]; then
		i_var=1
	else
		i_var=0
	fi

	echo "" > $TMP/pathscanresults.txt
	echo $PATH | sed 's/ /\\ /g' | sed 's/(/\\(/g' | 
	sed 's/)/\\)/g' | sed 's/:/\n/g' | 
	awk '{print "test -a "$0"/"'\"$input\"'"\nif [ $? == '\"$i_var\"' ]; then echo \"true\" >> $TMP/pathscanresults.txt\nelse echo \"false\" >> $TMP/pathscanresults.txt\nfi"}' > $TMP/pathscan.txt
	
	sh $TMP/pathscan.txt
	if [ $p_flag == true ]; then
		result=$( awk '{print $0}' $TMP/pathscanresults.txt )
		echo $result | sed 's/ /:/g'
	else
		cat $TMP/pathscanresults.txt
	fi
	exit 0
else
	echo $PATH | sed 's/:/\n/g'
fi

#-s and --search returns each path as a bool if path to input
#-f and --filter returns every path that exits
#-p and --package returns the result in $PATH format
#-i and --inverse adds onto -f and -s to invert results