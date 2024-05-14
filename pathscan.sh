#!/bin/sh

echo "" > $TMP/pathscanresults.txt

pathorg.sh | sed 's/ /\\ /g' | sed 's/(/\\(/g' | sed 's/)/\\)/g' |
awk '{print "test -a "$0"/"'\"$1\"'"\nif [ $? == 0 ]; then echo \""$0"/"'\"$1\"'"\" >> $TMP/pathscanresults.txt\nfi"}' > $TMP/pathscan.txt

sh $TMP/pathscan.txt
cat $TMP/pathscanresults.txt

echo "turns out 'which -a' already does what this does, so that is an f"
