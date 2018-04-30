#!/usr/bin/env bash

nifL=$1
nifH=$2
bdir='/home/stckscrnr/baseApp/app_db/OPTIONS_DATA'

while [ $nifL -le $nifH ]
do
	echo "CE,${nifL}" >> ${bdir}/$3/tmp.list
	echo "PE,${nifL}" >> ${bdir}/$3/tmp.list
	nifL=$((nifL+50))
done

	for file in $(ls ${bdir}/$3);
	do
	echo "$file"
	if [ $file == "OPT_NIFTY_CE_${3}.csv" ]
	then 
		grep -f ${bdir}/${3}/tmp.list ${bdir}/${3}/$file > ${bdir}/${3}/file.CE
	else
		grep -f ${bdir}/${3}/tmp.list ${bdir}/${3}/$file > ${bdir}/${3}/file.PE
	fi
	done
	 
