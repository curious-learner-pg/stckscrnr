#!/usr/bin/env bash

basedir="/home/stckscrnr/baseApp"

combine_data() {
	for file in `ls ${basedir}/app_histData/*20*.raw`
	do
	    echo "Combining file : $file to allData.raw"
	    cat ${file} >> ${basedir}/app_histData/allData.traw
	    sed -e 's/,$//g' < ${basedir}/app_histData/allData.traw > ${basedir}/app_histData/allData.raw
	done
}

filter_data() {
	for file in `ls ${basedir}/app_conf/*_stocks.list`
	do 
	    dbname=$(echo $file | cut -d"/" -f6)
	    echo "Filtering : $dbname"
	    echo "SYMBOL,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN"> ${basedir}/app_db/${dbname}.csv
	    grep -f $file ${basedir}/app_histData/allData.raw >> ${basedir}/app_db/${dbname}.csv
	done
}

combine_data

if [ -e ${basedir}/app_histData/allData.raw ]
then 
	echo "All data has been combined. Filtering now : "
	filter_data
else 
	echo "Combining failed - Manual efforts required"
fi

rm ${basedir}/app_histData/allData.*raw
