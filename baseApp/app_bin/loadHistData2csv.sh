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
	    echo "SYMBOL,OPEN,HIGH,LOW,CLOSE,LAST,PREVCLOSE,TOTTRDQTY,TOTTRDVAL,TIMESTAMP,TOTALTRADES,ISIN"> ${basedir}/app_db/FnOSTOCKS_DATA/${dbname}.csv
	    grep -f $file ${basedir}/app_histData/allData.raw >> ${basedir}/app_db/FnOSTOCKS_DATA/${dbname}.csv
	done
}

verify_load() {
	if [ $(($(wc -l ../app_conf/*_stocks.list | tail -1 | cut -f2 -d" ")*292+11)) -eq $((wc -l ../app_db/FnO_OPTIONS_DATA/*_stocks.list.csv | tail -1 | cut -f2 -d" "))  ]	
	then 
		echo "All records merged & available"
	else 
		echo "Some records missing please verify manually"
	fi
}

combine_data

if [ -e ${basedir}/app_histData/allData.raw ]
then 
	echo "All data has been combined. Filtering now : "
	filter_data
else 
	echo "Combining failed - Manual efforts required"
fi

verify_load

rm ${basedir}/app_histData/allData.*raw
